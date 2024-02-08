$inputROM=[System.IO.Path]::GetFullPath($args[0])
$inputASM=[System.IO.Path]::GetFullPath($args[1])
$output=[System.IO.Path]::GetFullPath($args[2])

$compilation = {
    $rev = (Get-Content $inputROM -Encoding Byte -ReadCount 1)[332]
    $english = if ((Get-Content $inputROM -Encoding Byte -ReadCount 1)[330] -eq 1) {0} else {1}
    echo "ROM revision: v1.$rev - $(if($english -eq 0){"English"}else{"Japanese"})"

    if (Test-Path -Path $output -PathType Leaf){
        rm $output
    }
    echo "[objects]`r`noutput.o" | out-file -encoding ASCII temp.prj
    ../wladx/wla-gb -D REV=$rev -D ENG=$english -o output.o $inputASM
    ../wladx/wlalink -s temp.prj $output
    rm temp.prj

    if (Test-Path -Path $output -PathType Leaf){
        echo "Success!"
    }else{
        echo "Something went wrong."
    }
}

Push-Location .\src
&$compilation
Pop-Location
