# Stage 1
FROM ocaml/opam:debian-ocaml-5.3 as build
RUN sudo apt-get update && sudo apt-get install -y libev-dev libssl-dev
WORKDIR /home/opam
COPY --chown=opam:opam dream_hello.opam .
RUN opam install . --deps-only -y
COPY --chown=opam:opam . .
RUN opam exec -- dune build @install --profile=release

# Stage 2
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libev4 libssl3 && rm -rf /var/lib/apt/lists/*
COPY --from=build /home/opam/_build/default/bin/main.exe /bin/server
EXPOSE 8080
CMD ["/bin/server"]
