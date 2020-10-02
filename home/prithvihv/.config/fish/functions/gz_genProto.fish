
function gz_genProto
    for file in db_*
        protoc -I=./$file/ ./$file/*.proto --go_out=plugins=grpc:./$file/proto
    end
end