FROM ubuntu AS builder
RUN apt-get update && apt-get upgrade
RUN apt-get install libgstrtspserver-1.0-dev -y
RUN apt-get install git make gcc -y
RUN git clone https://github.com/EATOPS/gst-rtsp-cli.git
RUN cd gst-rtsp-cli &&  make

FROM ubuntu
RUN apt-get update && apt-get upgrade
RUN apt-get install libgstrtspserver-1.0-0 gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly -y
COPY --from=builder /gst-rtsp-cli/dist ./

EXPOSE 8554
ENTRYPOINT ["./gst-rtsp-cli"]
CMD ["/test", "videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96"]