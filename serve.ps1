Add-Type -AssemblyName System.Net.HttpListener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
Write-Host "Serving files from $(Get-Location) at http://localhost:8080"
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $path = Join-Path (Get-Location) $context.Request.Url.LocalPath.TrimStart('/')
    if (Test-Path $path) {
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $context.Response.StatusCode = 404
    }
    $context.Response.Close()
}
