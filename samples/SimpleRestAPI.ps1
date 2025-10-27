# Simple PowerShell REST API service
# Save as e.g. rest-api.ps1 and run (may require elevated privileges to bind to http://+:8080/)
param(
    [string]$Prefix = "http://+:8080/"
)

# Add-Type -AssemblyName System.Net.HttpListener

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($Prefix)

$onCancel = {
    Write-Host "Shutting down listener..."
    try { $listener.Stop(); $listener.Close() } catch {}
    exit
}
[Console]::TreatControlCAsInput = $false
$null = [Console]::add_CancelKeyPress({ param($s,$e) $e.Cancel = $true; & $onCancel })

function Send-JsonResponse {
    param($context, $obj, $statusCode = 200)
    $resp = $context.Response
    $json = ($obj | ConvertTo-Json -Depth 10)
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
    $resp.StatusCode = $statusCode
    $resp.ContentType = "application/json; charset=utf-8"
    $resp.ContentLength64 = $buffer.Length
    $resp.OutputStream.Write($buffer, 0, $buffer.Length)
    $resp.OutputStream.Close()
}

function Handle-Request {
    param($context)
    try {
        $req = $context.Request
        $path = $req.Url.AbsolutePath.TrimEnd('/')
        $method = $req.HttpMethod.ToUpper()

        if ($method -eq 'GET' -and ($path -eq '' -or $path -eq '/')) {
            Send-JsonResponse $context @{ message = "Hello from PowerShell REST API"; path = $req.Url.AbsolutePath }
            return
        }

        if ($method -eq 'GET' -and $path -eq '/hello') {
            # $name = $req.QueryString['name'] ?: 'world'
            $name = $req.QueryString['name']
            if ($null -eq $name -or $name -eq '') { $name = 'world' }
            Send-JsonResponse $context @{ message = "Hello, $name" }
            return
        }

        if ($method -eq 'POST' -and $path -eq '/echo') {
            $reader = New-Object System.IO.StreamReader($req.InputStream, [System.Text.Encoding]::UTF8)
            $body = $reader.ReadToEnd()
            $reader.Close()
            # Try to parse JSON body, otherwise return raw string
            try {
                $parsed = $body | ConvertFrom-Json -ErrorAction Stop
                Send-JsonResponse $context @{ method = 'echo'; body = $parsed }
            } catch {
                Send-JsonResponse $context @{ method = 'echo'; body = $body }
            }
            return
        }

        # 404
        Send-JsonResponse $context @{ error = "Not found"; path = $req.Url.AbsolutePath } 404
    } catch {
        try {
            Send-JsonResponse $context @{ error = "Internal server error"; details = $_.Exception.Message } 500
        } catch {}
    }
}

try {
    $listener.Start()
    Write-Host "Listening on $($Prefix) ... Press Ctrl-C to stop."
    while ($listener.IsListening) {
        # This blocks until a request arrives
        # Handle request on threadpool to allow concurrent processing
        try {
            $context = $listener.GetContext()
            # [System.Threading.ThreadPool]::QueueUserWorkItem( { param($c) Handle-Request $c }, $context) | Out-Null
            Handle-Request $context
        } catch {
            Write-Host "Error queuing request: $($_.Exception.Message)" 
        }
    }   
} catch {
    Write-Host "Listener stopped: $($_.Exception.Message)"
} finally {
    try { $listener.Close() } catch {}
}