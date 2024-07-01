FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ADD . /nopcommerce
RUN mkdir nopcommerce/published && \
        cd /nopcommerce && \
        dotnet publish -c Release -o /nopcommerce/published /nopcommerce/src/Presentation/Nop.Web/Nop.Web.csproj

RUN mkdir /nopcommerce/published/bin /nopcommerce/published/logs
RUN /nopcommerce/published/bin /nopcommerce/published/logs


FROM mcr.microsoft.com/dotnet/aspnet:8.0
LABEL Author="Farida"
COPY --from=build /nopcommerce/published /app 
WORKDIR /app
USER nobody
EXPOSE 5000
CMD [ "dotnet", "Nop.Web.dll", "--urls", "http://0.0.0.0:5000" ]
