# 1️⃣ build stage
FROM ocaml/opam:debian-12-ocaml-5.2 as build
WORKDIR /app
RUN sudo apt update && sudo apt install -y pkg-config libev-dev
COPY . .
RUN opam install . --deps-only -y
RUN dune build --profile=release

# 2️⃣ runtime stage
FROM debian:12-slim
WORKDIR /app
COPY --from=build /app/_build/default/bin/main.exe /app/main
EXPOSE 8080
ENV PORT=8080
CMD ["/app/main"]
