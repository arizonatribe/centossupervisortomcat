FROM arizonatribe/centossupervisor
MAINTAINER David Nunez <arizonatribe@gmail.com>

ENV APP_NAME tcat 
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /opt/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

EXPOSE 8080
WORKDIR ${CATALINA_HOME}

# Install Java . . . eeew
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
	http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.tar.gz && \
	tar -xvf jdk-7u71-linux-x64.tar.gz && \
	rm jdk*.tar.gz && \
	mv jdk* ${JAVA_HOME}

# Install tomcat
RUN wget http://mirrors.ocf.berkeley.edu/apache/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz && \
    tar -xvf apache-tomcat-7*tar.gz && \
    rm apache-tomcat*.tar.gz && \
    mv apache-tomcat*/* ${CATALINA_HOME}

# Make sure the scripts are executable
RUN chmod a+x ${CATALINA_HOME}/bin/*sh

# Overlay, containing supervisord configs and other shell scripts
COPY docker /

# Create the tomcat user/group
RUN groupadd -r tomcat && \
    useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
    chown -R tomcat:tomcat ${CATALINA_HOME} /var/log

VOLUME ["/opt/scripts"]

USER tomcat

CMD ["/usr/bin/start"]

