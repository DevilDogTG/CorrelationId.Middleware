using DMNSN.AspNetCore.Middlewares.CorrelationId;
using Microsoft.AspNetCore.Http;

public class CorrelationIdMiddlewareTests
{
    [Fact]
    public async Task TestMiddlewareAddsCorrelationIdWhenEnabled()
    {
        var middleware = new CorrelationIdMiddleware((innerHttpContext) => Task.CompletedTask, new CorrelationIdMiddlewareOptions { EnableFeature = true });
        var context = new DefaultHttpContext();
        context.Response.Body = new MemoryStream();

        await middleware.InvokeAsync(context);

        Assert.True(context.Request.Headers.ContainsKey("X-Correlation-ID"));
        Assert.True(context.Response.Headers.ContainsKey("X-Correlation-ID"));
    }

    [Fact]
    public async Task TestMiddlewareDoesNothingWhenDisabled()
    {
        var middleware = new CorrelationIdMiddleware((innerHttpContext) => Task.CompletedTask, new CorrelationIdMiddlewareOptions { EnableFeature = false });
        var context = new DefaultHttpContext();
        context.Response.Body = new MemoryStream();

        await middleware.InvokeAsync(context);

        Assert.False(context.Request.Headers.ContainsKey("X-Correlation-ID"));
        Assert.False(context.Response.Headers.ContainsKey("X-Correlation-ID"));
    }
}
