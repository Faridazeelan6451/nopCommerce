FROM mcr.microsoft.com/dotnet/sdk:8.0 As build
ADD . /nopcommerce
# This is where we will be storing the nop build
RUN mkdir /nopcommerce/published
RUN cd /nopcommerce && \
    dotnet publish -c Release -o /nopcommerce/published /nopcommerce/src/Presentation/Nop.Web/Nop.Web.csproj
RUN mkdir /nopcommerce/published/bin /nopcommerce/published/logs


FROM mcr.microsoft.com/dotnet/aspnet:8.0
# create user
# add labels
COPY --from=build /nopcommerce/published /nop
WORKDIR /nop
EXPOSE 5000
CMD ["dotnet", "Nop.Web.dll", "--urls", "http://0.0.0.0:5000"]