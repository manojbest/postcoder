# postcoder

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](http://projects.spring.io/spring-cloud/)

Postcoder is a cloud-enabled, mobile-ready, AngularJS, Nodejs and Spring clould powered address data store for Ireland and United Kingdom countries which provides powerful way to retrieve address details very faster.

### Introduction
Create an API service, query it with some Irish, UK Eircodes and receive JSON response with the address details. There is a third party API available (free for limited use) with the information needed. These are the two endpoints that require implementation.

- https://developers.alliescomputing.com/postcoder-web-api/address-lookup/eircode
- https://developers.alliescomputing.com/postcoder-web-api/address-lookup/premise

##### why?
Each call to the third party API has a cost of 4.5 credits per request. We expect this API being called by multiple services that all together add up to one million requests per month. In order to minimize the costs we need to minimize the number of requests to the third party API, without interfering with how the consumer services work.

### Development
Entire system is layered down to 7 diffrent components and which is based on the spring cloud architecture. Each component in the postcoder is independent means that it is running on a separate docker container.

##### Component Diagram


###### 1. ui-service
This is the User Interface of postcoder which is based on AngularJs. Ui-service is running on a separate docker container from nginx server. 
For more information https://github.com/manojbest/ui-service

###### 2. edge-service
This acts as a proxy for the ui-service. The goal is to work around CORS and the Same Origin Policy restriction of the browser and allow the UI to call the API even though they don’t share the same origin. It also modifies the API response as ui-service needed. Edge-servicein has been used in the UI application to proxy calls to the REST API. 
Edge-service is based on Spring Cloud's zuul proxy which runs on a separate docker container .
For more information https://github.com/manojbest/edge-service

###### 3. eureka-service
This is the service registry in postcoder where microservices can register themselves so others can discover them.
Eureka-service is based on Spring Cloud's eureka server which runs on a separate docker container .
For more information https://github.com/manojbest/eureka-service

###### 4. eir-code-service
This is one of the main component in postcoder where all the business logic resides for Irish address lookup for the URL https://developers.alliescomputing.com/postcoder-web-api/address-lookup/eircode.
Eir-code-service is based on Spring boot which runs on a separate docker container and it is one of the client of eureka server. It fetches address details from third-party API's and caches it in the redis server. When second query gets, it does not take it from API's instead retrieves it from the redis cache.
For more information https://github.com/manojbest/eir-code-service

###### 5. uk-code-service
This is one of the main component in postcoder where all the business logic resides for Premise address lookup for the URL https://developers.alliescomputing.com/postcoder-web-api/address-lookup/premise.
Uk-code-service is based on nodejs which runs on a separate docker container and it uses hapijs for server. It fetches address details from third-party API's and caches it in the redis server. When second query gets, it does not take it from API's instead retrieves it from the redis cache.
For more information https://github.com/manojbest/uk-code-service

###### 6. sidecar-service
This acts as a middle tier between eureka-service and uk-code-service. It connects non-Java application which is uk-code-service (it is based on nodejs) to eureka-service.
For more information https://github.com/manojbest/sidecar-service

###### 7. redis
Redis is used as data store in the postcoder where it caches address details from third-party API's.