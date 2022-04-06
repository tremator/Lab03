### INSTALACION DE PAQUETES
install.packages("RODBC")
install.packages("dplyr")

### IMPORTACION DE PAQUETES

library(RODBC)
library(dplyr)

### Obtencion de la data de base datos

con_sql <- odbcConnect("SQLLAB",uid = "Daniel",pwd ="162534")

clientes <- sqlQuery(con_sql,"SELECT * FROM dbo.Customers")
head(clientes)

pedidos <- sqlQuery(con_sql,"SELECT * FROM dbo.Orders")
head(pedidos)

detalle_pedidos <- sqlQuery(con_sql,"SELECT * FROM dbo.[Order Details]")
head(detalle_pedidos)

### creacion del data frame uniendo las tres tablas

data <- inner_join(pedidos,detalle_pedidos,by = "OrderID")%>% inner_join(.,clientes, by = "CustomerID")
head(data)

### exploracion de datos

head(data)
glimpse(data)
str(data)
tail(data)
class(data)
summary(data)
which(is.na(data))
names(data)
colnames(data)

### Mofificacion de los tipos de datos

data$ShipName <- as.factor(data$ShipName)
data$CustomerID <- as.factor(data$CustomerID)
data$ShipAddress <- as.factor(data$ShipAddress)
data$ShipCity <- as.factor(data$ShipCity)
data$ShipCountry <- as.factor(data$ShipCountry)
data$ShipRegion <- as.factor(data$ShipRegion)
data$PostalCode <- as.factor(data$PostalCode)
data$CompanyName <- as.factor(data$CompanyName)
data$ContactName <- as.factor(data$ContactName)
data$ContactTitle <- as.factor(data$ContactTitle)
data$Address <- as.factor(data$Address)
data$City <- as.factor(data$City)
data$Region <- as.factor(data$Region)
data$Country <- as.factor(data$Country)
data$Phone <- as.factor(data$Phone)
data$Fax <- as.factor(data$Fax)
data$ShipPostalCode <- as.factor(data$ShipPostalCode)
data$OrderDate <- as.Date(data$OrderDate)
data$RequiredDate <- as.Date(data$RequiredDate)
data$ShippedDate <- as.Date(data$ShippedDate)
data$UnitPrice <- as.double(data$UnitPrice)


### frecuencia de tipos de datos

table(data["ShipName","ShipAddress"],useNA = "always")

mean(is.na(data))

apply(is.na(data), 2, sum)



