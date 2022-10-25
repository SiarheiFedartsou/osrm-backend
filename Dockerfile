FROM dockcross/linux-arm64-lts

RUN apt-get update -y && apt-get install -y python3 python3-pip nodejs
RUN pip install conan
