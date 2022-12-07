# here <build> is alias and whole FROM line is one stage of Dockerfile
# whenever we want another stage of dockerfile we directly call it by <build>
FROM maven as build
# all the file will be go to container's <app> directory
WORKDIR /app
# here one . for current working dir and second . for conatiner's current working dir coz we already set /app is current working dir
COPY . .
# after all these steps maven will create a new directory named /app/target and here our articat will be saved i.e /app/target/Uber.jar

# from here second satge of dockerfile start
FROM openjdk:11.0
# again we want to put everything in /app folder of container
WORKDIR /app
# now we copy what ever we build from 1st satge to this 2nd stage using alias and copy this .jar artifact to /app dir
COPY --from=build /app/target/Uber.jar  /app
EXPOSE 9090
# now give some command to run this container otherwise it will stop
CMD ["java", "jar", "Uber.jar"]
