$input_dir = (Resolve-Path ".\input").Path
$output_dir = (Resolve-Path ".\output").Path

Get-ChildItem -Path $input_dir -Recurse -Filter *.ttf | ForEach-Object {
  $input_file = $_.FullName

  $relative_path = $input_file.Substring($input_dir.Length).TrimStart("\")
  $output_full_dir = Join-Path -Path $output_dir -ChildPath (Split-Path $relative_path -Parent)

  if (!(Test-Path -Path $output_full_dir)) {
    New-Item -ItemType Directory -Path $output_full_dir | Out-Null
  }

  $output_file = Join-Path -Path $output_full_dir -ChildPath ($_.BaseName + ".woff2")

  Write-Output "Converting $input_file to $output_file"
  & .\ttf2woff2.exe -o $output_file $input_file
}

Write-Output "Conversion completed"

Pause