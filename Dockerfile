FROM dockcross/linux-arm64-lts

ENV DEFAULT_DOCKCROSS_IMAGE my_cool_image
RUN apt-get update -y && apt-get install -y python3 python3-pip nodejs
RUN pip install conan
