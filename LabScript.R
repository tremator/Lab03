### INSTALACION DE PAQUETES
install.packages("RODBC")
install.packages("dplyr")
install.packages("ggplot2")

### IMPORTACION DE PAQUETES

library(RODBC)
library(dplyr)
library(ggplot2)

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

ggplot(data,aes(x=data$Quantity, y=data$UnitPrice))+geom_boxplot()

apply(is.na(data), 2, sum)

data2 <- select(data,CompanyName,City,Region,Country,OrderDate,Quantity,UnitPrice,ProductID)

total <-as.data.frame(data2$UnitPrice * data2$Quantity)
glimpse(total)
data2 <- cbind(data2,total)
head(data2)

colnames(data2) <- c('CompanyName','City','Region','Country','OrderDate','Quantity','UnitPrice','ProductoID','Total_Sells')

Year <- as.data.frame(format(data2$OrderDate,'%Y'))
Month <- as.data.frame(format(data2$OrderDate,'%m'))

colnames(Year) <- c('Year')
colnames(Month) <- c('Month')

data2 <- cbind(data2,Year)
data2 <- cbind(data2,Month)

data2$Year <- as.numeric(data2$Year)
data2$Month <- as.numeric(data2$Month)
Except <- filter(data2,data2$Year >=1997)

ggplot(data2,aes(x = City,y = Total_Sells))+ geom_bar(stat = "identity")

ggplot(Except,aes(x = Year,y = Total_Sells))+ geom_bar(stat = "identity")
ggplot(data2,aes(x = data2$CompanyName,y = Total_Sells))+ geom_bar(stat = "identity")


VentaCliente <- data2 %>% group_by(Country) %>% summarise(CompanyName)

ggplot(VentaCliente,aes(x = VentaCliente$Country,y = CompanyName))+ geom_bar(stat = "identity")

ventas <- data2 %>% group_by(Country) %>% group_by(ProductID) %>%summarise(total)


