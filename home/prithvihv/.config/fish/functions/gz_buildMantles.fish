
function gz_genProto
    for file in db_*
        env GOOS=linux GOARCH=amd64 go build -o $file/build/mantle_$file $file/*.go
    end
end