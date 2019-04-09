// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace AvePoint.PowerShell.FLYMigration
{
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for ExchangePlan.
    /// </summary>
    public static partial class ExchangePlanExtensions
    {
            /// <summary>
            /// Create a new migration plan
            /// </summary>
            /// <remarks>
            /// Create a new migration plan by passing the plan settings
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='plan'>
            /// Detailed settings of the plan
            /// </param>
            public static ServiceResponsePlanSummaryModel Add(this IExchangePlan operations, ExchangePlanModel plan)
            {
                return operations.AddAsync(plan).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Create a new migration plan
            /// </summary>
            /// <remarks>
            /// Create a new migration plan by passing the plan settings
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='plan'>
            /// Detailed settings of the plan
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ServiceResponsePlanSummaryModel> AddAsync(this IExchangePlan operations, ExchangePlanModel plan, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.AddWithHttpMessagesAsync(plan, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
