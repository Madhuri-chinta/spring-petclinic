FROM ubuntu:22.04 as build
RUN apt-get update
RUN apt-get install openjdk-17-jdk -y
RUN apt-get install maven -y
RUN apt-get install git -y
RUN git clone https://github.com/Madhuri-chinta/spring-petclinic.git && \
    cd spring-petclinic && \
    mvn package

FROM openjdk:17 
LABEL project="springpetclinic" 
LABEL author="Madhuri"
COPY --from=build /spring-petclinic/target/spring-petclinic-3.0.0-SNAPSHOT.jar spring-petclinic-3.0.0-SNAPSHOT.jar
EXPOSE 8080
CMD ["java","-jar","spring-petclinic-3.0.0-SNAPSHOT.jar"]