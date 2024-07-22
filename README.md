# DMNSN.AspNetCore.Middlewares.CorrelationId

This middleware is designed to monitor and manage correlation IDs across incoming requests and outgoing responses in ASP.NET Core applications. It ensures that every operation within your application can be traced with a unique identifier, making debugging and monitoring significantly easier.

## Features

- **Automatic Correlation ID Management:** Automatically assigns a correlation ID to incoming requests if one is not present.
- **Customizable Correlation ID Key:** Allows customization of the HTTP header key used for the correlation ID.
- **Configurable through appsettings.json:** Easily configure the middleware's behavior through the application's configuration file.

## Getting Started

### Prerequisites

- .NET 8.0 SDK or later
- An existing ASP.NET Core project

### Installation

1. Add the middleware to your project by including it in your `csproj` file or using NuGet Package Manager.

2. Ensure your project file (`DMNSN.AspNetCore.Middlewares.CorrelationId.csproj`) includes the necessary dependencies:

```xml
<ItemGroup>
    <FrameworkReference Include="Microsoft.AspNetCore.App" />
    <PackageReference Include="Microsoft.Extensions.Options" Version="8.0.2" />
</ItemGroup>
```

### Usage

1. In your `Startup.cs` or wherever you configure your HTTP request pipeline, add the middleware:

```csharp
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    // Other configurations...

    app.UseCorrelationIdMiddleware(Configuration);

    // Continue with the rest of the pipeline...
}
```

2. Optionally, you can customize the middleware options by adding a section in your `appsettings.json`:

```json
"DMNSN": {
    "Middlewares": {
        "CorrelationId": {
            "EnableFeature": true,
            "CorrelationKey": "X-Correlation-ID"
        }
    }
}
```

1. If you prefer to pass options programmatically, you can use the `UseCorrelationIdMiddleware` extension method:

```csharp
app.UseCorrelationIdMiddleware(new CorrelationIdMiddlewareOptions
{
    EnableFeature = true,
    CorrelationKey = "X-Correlation-ID"
});
```

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues to discuss potential improvements or fixes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
