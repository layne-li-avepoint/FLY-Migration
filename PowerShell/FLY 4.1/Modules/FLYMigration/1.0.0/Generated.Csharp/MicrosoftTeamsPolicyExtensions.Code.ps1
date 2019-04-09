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
    /// Extension methods for MicrosoftTeamsPolicy.
    /// </summary>
    public static partial class MicrosoftTeamsPolicyExtensions
    {
            /// <summary>
            /// Get migration policies
            /// </summary>
            /// <remarks>
            /// Returns a list of migration policies
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static ServiceResponseListPolicySummaryModel Get(this IMicrosoftTeamsPolicy operations)
            {
                return operations.GetAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get migration policies
            /// </summary>
            /// <remarks>
            /// Returns a list of migration policies
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ServiceResponseListPolicySummaryModel> GetAsync(this IMicrosoftTeamsPolicy operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
