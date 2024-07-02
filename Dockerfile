FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ADD . /nopcommerce
# This is where we will be storing the nop build
RUN mkdir /nopcommerce/published
RUN cd /nopcommerce && \
    dotnet publish -c Release -o /nopcommerce/published /nopcommerce/src/Presentation/Nop.Web/Nop.Web.csproj
RUN mkdir /nopcommerce/published/bin /nopcommerce/published/logs


FROM mcr.microsoft.com/dotnet/aspnet:8.0
LABEL Author = "Farida"
LABEL project="nopCommerce"
RUN useradd -d /app -m -s /bin/bash nop
USER nop
COPY --from=build --chown=nop:nop  /nopcommerce/published /app
WORKDIR /app
EXPOSE 5000
CMD ["dotnet", "Nop.Web.dll", "--urls", "http://0.0.0.0:5000"]