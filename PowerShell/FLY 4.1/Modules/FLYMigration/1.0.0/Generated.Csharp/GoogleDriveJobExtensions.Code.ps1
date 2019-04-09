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
    /// Extension methods for GoogleDriveJob.
    /// </summary>
    public static partial class GoogleDriveJobExtensions
    {
            /// <summary>
            /// Rerun a migration job
            /// </summary>
            /// <remarks>
            /// Rerun a migration job by the job ID. It allows to configure the migration
            /// type, define the migration scope, and set the job start time.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='id'>
            /// The Id of the job that needs to be executed again
            /// </param>
            /// <param name='setting'>
            /// Detailed settings of the job
            /// </param>
            public static ServiceResponseString Restart(this IGoogleDriveJob operations, string id, JobExecutionModel setting)
            {
                return operations.RestartAsync(id, setting).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Rerun a migration job
            /// </summary>
            /// <remarks>
            /// Rerun a migration job by the job ID. It allows to configure the migration
            /// type, define the migration scope, and set the job start time.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='id'>
            /// The Id of the job that needs to be executed again
            /// </param>
            /// <param name='setting'>
            /// Detailed settings of the job
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ServiceResponseString> RestartAsync(this IGoogleDriveJob operations, string id, JobExecutionModel setting, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.RestartWithHttpMessagesAsync(id, setting, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
