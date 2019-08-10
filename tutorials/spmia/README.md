Book: Spring Microservices in Action
====================================

Authentication-Service - OAuth2 Login
-------------------------------------

    # http://minikube:30000/ - with NodePort service
    # http://spmia.minikube/auth/oauth/token - with Nginx Ingress controller
    http --auth=eagleeye:thisissecret --form POST http://localhost:8901/oauth/token grant_type=password scope=webclient username=john.carnell password=password1
    …
    {
        "access_token": "12baa05f-1ed3-4db1-92ad-407b73ea4063",
        "expires_in": 42893,
        "refresh_token": "00fc235c-6977-4e84-aa48-96888fee559d",
        "scope": "webclient",
        "token_type": "bearer"
    }

Authentication-Service - OAuth2 Refresh
---------------------------------------

    # http://minikube:30000/
    # http://spmia.minikube/auth/oauth/token - with Nginx Ingress controller
    http --auth=eagleeye:thisissecret --form POST http://localhost:8901/oauth/token grant_type=refresh_token scope=webclient refresh_token=00fc235c-6977-4e84-aa48-96888fee559d
    …
    {
        "access_token": "bd67e87d-14f0-460a-a950-c08b00bf73e1",
        "expires_in": 43199,
        "refresh_token": "00fc235c-6977-4e84-aa48-96888fee559d",
        "scope": "webclient",
        "token_type": "bearer"
    }

Authentication-Service - User Information
-----------------------------------------

    Applications use this request to check the validity of the OAuth2 Access-Token and to retrieve information
    about the currently logged-in user. They copy the Authorization-Header they receive into their request to
    the Authentication-Service.

    http GET http://localhost:8901/user Authorization:"Bearer $ACCESS_TOKEN"
    …
    {
        "authorities": [
            "ROLE_USER"
        ],
        "user": {
            "accountNonExpired": true,
            "accountNonLocked": true,
            "authorities": [
                {
                    "authority": "ROLE_USER"
                }
            ],
            "credentialsNonExpired": true,
            "enabled": true,
            "password": null,
            "username": "john.carnell"
        }
    }

Organization Service
--------------------

    # http://spmia.minikube/org/v1/organizations/ - with Nginx Ingress controller
    http GET http://localhost:8085/v1/organizations/ Authorization:"Bearer $ACCESS_TOKEN"
    …
    [
        {
            "contactEmail": "mark.balster@custcrmco.com",
            "contactName": "Mark Balster",
            "contactPhone": "823-555-1212",
            "id": "e254f8c-c442-4ebe-a82a-e2fc1d1ff78a",
            "name": "customer-crm-co"
        },
        {
            "contactEmail": "doug.drewry@hr.com",
            "contactName": "Doug Drewry",
            "contactPhone": "920-555-1212",
            "id": "442adb6e-fa58-47f3-9ca2-ed1fecdfe86c",
            "name": "HR-PowerSuite"
        }
    ]

Licensing Service
------------------

Caveat: Unavailable in the first 30s or so due to Hystrix!

    # http://minikube:30006/…
    # http://spmia.minikube/lic/v1/organizations/442adb6e-fa58-47f3-9ca2-ed1fecdfe86c/licenses/ - with Nginx Ingress controller
    http GET http://localhost:8080/v1/organizations/442adb6e-fa58-47f3-9ca2-ed1fecdfe86c/licenses/ Authorization:"Bearer $ACCESS_TOKEN"
    …
    [
        {
            "comment": null,
            "contactEmail": "",
            "contactName": "",
            "contactPhone": "",
            "licenseAllocated": 4,
            "licenseId": "38777179-7094-4200-9d61-edb101c6ea84",
            "licenseMax": 100,
            "licenseType": "user",
            "organizationId": "442adb6e-fa58-47f3-9ca2-ed1fecdfe86c",
            "organizationName": "",
            "productName": "HR-PowerSuite"
        },
        …
    
Configuration Service
---------------------

TODO: Where is the authentication?

    # http://minikube:30007/…
    http GET http://localhost:8888/organizationservice/dev
    …
    {
        "label": "master", 
        "name": "organizationservice", 
        "profiles": [
            "dev"
        ], 
        "propertySources": [
            {
                "name": "https://github.com/carnellj/config-repo/organizationservice/organizationservice-dev.yml", 
                "source": {
                    "signing.key": "345345fsdfsf5345", 
                    "spring.database.driverClassName": "org.postgresql.Driver", 
                    "spring.datasource.password": "{cipher}d495ce8603af958b2526967648aa9620b7e834c4eaff66014aa805450736e119", 
                    "spring.datasource.platform": "postgres", 
                    "spring.datasource.testWhileIdle": "true",
                    "spring.datasource.url": "jdbc:postgresql://database:5432/eagle_eye_dev",
                    "spring.datasource.username": "postgres_dev",
                    "spring.datasource.validationQuery": "SELECT 1",
                    "spring.jpa.database": "POSTGRESQL",
                    "spring.jpa.properties.hibernate.dialect": "org.hibernate.dialect.PostgreSQLDialect",
                    "spring.jpa.show-sql": "false"
                }
            },
            …

Eureka Service
--------------

    # http://minikube:30003/
    # http http://spmia.minikube/eureka/eureka/apps/ Authorization:"Bearer $ACCESS_TOKEN"
    http GET http://localhost:8761/eureka/apps/ Accept:application/json
    …
    {
        "applications": {
            "application": [
                {
                    "instance": [
                        {
                            "actionType": "ADDED", 
                            "app": "CONFIGSERVER", 
                            "countryId": 1, 
                            "dataCenterInfo": {
                                "@class": "com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo", 
                                "name": "MyOwn"
                            }, 
                            "healthCheckUrl": "http://aef006790d69:8888/health", 
                            "homePageUrl": "http://aef006790d69:8888/", 
                            "hostName": "aef006790d69", 
                            "instanceId": "aef006790d69:configserver:8888", 
                            "ipAddr": "172.17.0.5", 
                            …

Zuul Service
------------

API gateway that, among other things, the tmx-correlation-id header inserts.

    # http://minikube:30008
    http GET http://localhost:5555/api/licensing/v1/organizations/442adb6e-fa58-47f3-9ca2-ed1fecdfe86c/licenses/  Authorization:"Bearer $ACCESS_TOKEN"
    …
    HTTP/1.1 200
    tmx-correlation-id: 05f08787-f751-471a-9408-b7ae6ca536c9
    …
     [
         {
             "comment": null,
             "contactEmail": "",
             "contactName": "",
             "contactPhone": "",
             "licenseAllocated": 4,
             "licenseId": "38777179-7094-4200-9d61-edb101c6ea84",
             "licenseMax": 100,
             "licenseType": "user",
             "organizationId": "442adb6e-fa58-47f3-9ca2-ed1fecdfe86c",
             "organizationName": "",
             "productName": "HR-PowerSuite"
         },
         …
         
         
                            
