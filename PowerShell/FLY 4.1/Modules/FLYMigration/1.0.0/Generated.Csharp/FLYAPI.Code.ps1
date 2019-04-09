// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace AvePoint.PowerShell.FLYMigration
{
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Models;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Net;
    using System.Net.Http;

    /// <summary>
    /// &lt;div&gt;&lt;p&gt;FLY API provides programmatic access to trigger and
    /// manage migration jobs through Web API endpoints. To call FLY API, you
    /// must get the API key from FLY interface &gt; Management &gt; General
    /// Settings &gt; &lt;a target='_blank'
    /// href='/#!/settings/general-settings/apikeys' rel='noopener noreferrer'
    /// class='link'&gt;API Keys&lt;/a&gt;. For every Web API call, the API key
    /// must be attached to the Authorization header in the HTTP
    /// request.&lt;/p&gt;&lt;/div&gt;
    /// &lt;div class='dxp-docFrame'&gt;Authorization: api_key
    /// Mgo8CM3TLB0Kgxdqp9RwKTjBt/p ... E/dBN0Q1/vjzjx0qftB/jc&lt;/div&gt;
    /// &lt;div&gt;&lt;p&gt;In this page, you can try and test the API
    /// endpoints by copying and pasting the API key to the api_key text box
    /// above.&lt;/p&gt;&lt;/div&gt;
    /// &lt;div&gt;&lt;p&gt;Refer to &lt;a target='_blank'
    /// href='https://github.com/AvePoint/FLY-Migration/tree/master/WebAPI'
    /// rel='noopener noreferrer'&gt;Sample Codes&lt;/a&gt; for more sample
    /// codes.&lt;/p&gt;&lt;/div&gt;
    /// &lt;div&gt;&lt;p&gt;If you would like to write PowerShell scripts,
    /// please refer to &lt;a target='_blank'
    /// href='https://github.com/AvePoint/FLY-Migration/tree/master/PowerShell'
    /// rel='noopener noreferrer' class='link'&gt;PowerShell&lt;/a&gt; for more
    /// details.&lt;/p&gt;&lt;/div&gt;
    /// </summary>
    public partial class FLYAPI : ServiceClient<FLYAPI>, IFLYAPI
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        public System.Uri BaseUri { get; set; }

        /// <summary>
        /// Gets or sets json serialization settings.
        /// </summary>
        public JsonSerializerSettings SerializationSettings { get; private set; }

        /// <summary>
        /// Gets or sets json deserialization settings.
        /// </summary>
        public JsonSerializerSettings DeserializationSettings { get; private set; }

        /// <summary>
        /// Subscription credentials which uniquely identify client subscription.
        /// </summary>
        public ServiceClientCredentials Credentials { get; private set; }

        /// <summary>
        /// Gets the IBoxConnection.
        /// </summary>
        public virtual IBoxConnection BoxConnection { get; private set; }

        /// <summary>
        /// Gets the IBoxJobs.
        /// </summary>
        public virtual IBoxJobs BoxJobs { get; private set; }

        /// <summary>
        /// Gets the IBoxJob.
        /// </summary>
        public virtual IBoxJob BoxJob { get; private set; }

        /// <summary>
        /// Gets the IBoxPlan.
        /// </summary>
        public virtual IBoxPlan BoxPlan { get; private set; }

        /// <summary>
        /// Gets the IBoxJobsByPlan.
        /// </summary>
        public virtual IBoxJobsByPlan BoxJobsByPlan { get; private set; }

        /// <summary>
        /// Gets the IBoxJobByPlan.
        /// </summary>
        public virtual IBoxJobByPlan BoxJobByPlan { get; private set; }

        /// <summary>
        /// Gets the IBoxPolicy.
        /// </summary>
        public virtual IBoxPolicy BoxPolicy { get; private set; }

        /// <summary>
        /// Gets the IExchangeConnections.
        /// </summary>
        public virtual IExchangeConnections ExchangeConnections { get; private set; }

        /// <summary>
        /// Gets the IExchangeJobs.
        /// </summary>
        public virtual IExchangeJobs ExchangeJobs { get; private set; }

        /// <summary>
        /// Gets the IExchangeJob.
        /// </summary>
        public virtual IExchangeJob ExchangeJob { get; private set; }

        /// <summary>
        /// Gets the IExchangePlans.
        /// </summary>
        public virtual IExchangePlans ExchangePlans { get; private set; }

        /// <summary>
        /// Gets the IExchangePlan.
        /// </summary>
        public virtual IExchangePlan ExchangePlan { get; private set; }

        /// <summary>
        /// Gets the IExchangeJobsByPlan.
        /// </summary>
        public virtual IExchangeJobsByPlan ExchangeJobsByPlan { get; private set; }

        /// <summary>
        /// Gets the IExchangeJobByPlan.
        /// </summary>
        public virtual IExchangeJobByPlan ExchangeJobByPlan { get; private set; }

        /// <summary>
        /// Gets the IExchangePolicies.
        /// </summary>
        public virtual IExchangePolicies ExchangePolicies { get; private set; }

        /// <summary>
        /// Gets the IFSConnections.
        /// </summary>
        public virtual IFSConnections FSConnections { get; private set; }

        /// <summary>
        /// Gets the IFSJobs.
        /// </summary>
        public virtual IFSJobs FSJobs { get; private set; }

        /// <summary>
        /// Gets the IFSJob.
        /// </summary>
        public virtual IFSJob FSJob { get; private set; }

        /// <summary>
        /// Gets the IFSPlans.
        /// </summary>
        public virtual IFSPlans FSPlans { get; private set; }

        /// <summary>
        /// Gets the IFSPlan.
        /// </summary>
        public virtual IFSPlan FSPlan { get; private set; }

        /// <summary>
        /// Gets the IFSJobsByPlan.
        /// </summary>
        public virtual IFSJobsByPlan FSJobsByPlan { get; private set; }

        /// <summary>
        /// Gets the IFSJobByPlan.
        /// </summary>
        public virtual IFSJobByPlan FSJobByPlan { get; private set; }

        /// <summary>
        /// Gets the IFSPolicies.
        /// </summary>
        public virtual IFSPolicies FSPolicies { get; private set; }

        /// <summary>
        /// Gets the IGmailConnection.
        /// </summary>
        public virtual IGmailConnection GmailConnection { get; private set; }

        /// <summary>
        /// Gets the IGmailJobs.
        /// </summary>
        public virtual IGmailJobs GmailJobs { get; private set; }

        /// <summary>
        /// Gets the IGmailJob.
        /// </summary>
        public virtual IGmailJob GmailJob { get; private set; }

        /// <summary>
        /// Gets the IGmailPlan.
        /// </summary>
        public virtual IGmailPlan GmailPlan { get; private set; }

        /// <summary>
        /// Gets the IGmailJobsByPlan.
        /// </summary>
        public virtual IGmailJobsByPlan GmailJobsByPlan { get; private set; }

        /// <summary>
        /// Gets the IGmailJobByPlan.
        /// </summary>
        public virtual IGmailJobByPlan GmailJobByPlan { get; private set; }

        /// <summary>
        /// Gets the IGmailPolicy.
        /// </summary>
        public virtual IGmailPolicy GmailPolicy { get; private set; }

        /// <summary>
        /// Gets the IGoogleDriveConnection.
        /// </summary>
        public virtual IGoogleDriveConnection GoogleDriveConnection { get; private set; }

        /// <summary>
        /// Gets the IGoogleDriveJobs.
        /// </summary>
        public virtual IGoogleDriveJobs GoogleDriveJobs { get; private set; }

        /// <summary>
        /// Gets the IGoogleDriveJob.
        /// </summary>
        public virtual IGoogleDriveJob GoogleDriveJob { get; private set; }

        /// <summary>
        /// Gets the IGoogleDrivePlan.
        /// </summary>
        public virtual IGoogleDrivePlan GoogleDrivePlan { get; private set; }

        /// <summary>
        /// Gets the IGoogleDriveJobsByPlan.
        /// </summary>
        public virtual IGoogleDriveJobsByPlan GoogleDriveJobsByPlan { get; private set; }

        /// <summary>
        /// Gets the IGoogleDriveJobByPlan.
        /// </summary>
        public virtual IGoogleDriveJobByPlan GoogleDriveJobByPlan { get; private set; }

        /// <summary>
        /// Gets the IGoogleDrivePolicy.
        /// </summary>
        public virtual IGoogleDrivePolicy GoogleDrivePolicy { get; private set; }

        /// <summary>
        /// Gets the IIMAPPOP3Jobs.
        /// </summary>
        public virtual IIMAPPOP3Jobs IMAPPOP3Jobs { get; private set; }

        /// <summary>
        /// Gets the IIMAPPOP3Job.
        /// </summary>
        public virtual IIMAPPOP3Job IMAPPOP3Job { get; private set; }

        /// <summary>
        /// Gets the IIMAPPOP3Plan.
        /// </summary>
        public virtual IIMAPPOP3Plan IMAPPOP3Plan { get; private set; }

        /// <summary>
        /// Gets the IIMAPPOP3JobsByPlan.
        /// </summary>
        public virtual IIMAPPOP3JobsByPlan IMAPPOP3JobsByPlan { get; private set; }

        /// <summary>
        /// Gets the IIMAPPOP3JobByPlan.
        /// </summary>
        public virtual IIMAPPOP3JobByPlan IMAPPOP3JobByPlan { get; private set; }

        /// <summary>
        /// Gets the IIMAPPOP3Policy.
        /// </summary>
        public virtual IIMAPPOP3Policy IMAPPOP3Policy { get; private set; }

        /// <summary>
        /// Gets the IMicrosoftTeamsConnection.
        /// </summary>
        public virtual IMicrosoftTeamsConnection MicrosoftTeamsConnection { get; private set; }

        /// <summary>
        /// Gets the IMicrosoftTeamsJobs.
        /// </summary>
        public virtual IMicrosoftTeamsJobs MicrosoftTeamsJobs { get; private set; }

        /// <summary>
        /// Gets the IMicrosoftTeamsJob.
        /// </summary>
        public virtual IMicrosoftTeamsJob MicrosoftTeamsJob { get; private set; }

        /// <summary>
        /// Gets the IMicrosoftTeamsPlan.
        /// </summary>
        public virtual IMicrosoftTeamsPlan MicrosoftTeamsPlan { get; private set; }

        /// <summary>
        /// Gets the IMicrosoftTeamsJobsByPlan.
        /// </summary>
        public virtual IMicrosoftTeamsJobsByPlan MicrosoftTeamsJobsByPlan { get; private set; }

        /// <summary>
        /// Gets the IMicrosoftTeamsJobByPlan.
        /// </summary>
        public virtual IMicrosoftTeamsJobByPlan MicrosoftTeamsJobByPlan { get; private set; }

        /// <summary>
        /// Gets the IMicrosoftTeamsPolicy.
        /// </summary>
        public virtual IMicrosoftTeamsPolicy MicrosoftTeamsPolicy { get; private set; }

        /// <summary>
        /// Gets the IOffice365GroupConnection.
        /// </summary>
        public virtual IOffice365GroupConnection Office365GroupConnection { get; private set; }

        /// <summary>
        /// Gets the IOffice365GroupJobs.
        /// </summary>
        public virtual IOffice365GroupJobs Office365GroupJobs { get; private set; }

        /// <summary>
        /// Gets the IOffice365GroupJob.
        /// </summary>
        public virtual IOffice365GroupJob Office365GroupJob { get; private set; }

        /// <summary>
        /// Gets the IOffice365GroupPlan.
        /// </summary>
        public virtual IOffice365GroupPlan Office365GroupPlan { get; private set; }

        /// <summary>
        /// Gets the IOffice365GroupJobsByPlan.
        /// </summary>
        public virtual IOffice365GroupJobsByPlan Office365GroupJobsByPlan { get; private set; }

        /// <summary>
        /// Gets the IOffice365GroupJobByPlan.
        /// </summary>
        public virtual IOffice365GroupJobByPlan Office365GroupJobByPlan { get; private set; }

        /// <summary>
        /// Gets the IOffice365GroupPolicy.
        /// </summary>
        public virtual IOffice365GroupPolicy Office365GroupPolicy { get; private set; }

        /// <summary>
        /// Gets the ISPJobs.
        /// </summary>
        public virtual ISPJobs SPJobs { get; private set; }

        /// <summary>
        /// Gets the ISPJob.
        /// </summary>
        public virtual ISPJob SPJob { get; private set; }

        /// <summary>
        /// Gets the ISPPlans.
        /// </summary>
        public virtual ISPPlans SPPlans { get; private set; }

        /// <summary>
        /// Gets the ISPPlan.
        /// </summary>
        public virtual ISPPlan SPPlan { get; private set; }

        /// <summary>
        /// Gets the ISPJobsByPlan.
        /// </summary>
        public virtual ISPJobsByPlan SPJobsByPlan { get; private set; }

        /// <summary>
        /// Gets the ISPJobByPlan.
        /// </summary>
        public virtual ISPJobByPlan SPJobByPlan { get; private set; }

        /// <summary>
        /// Gets the ISPPolicies.
        /// </summary>
        public virtual ISPPolicies SPPolicies { get; private set; }

        /// <summary>
        /// Gets the ISlackConnection.
        /// </summary>
        public virtual ISlackConnection SlackConnection { get; private set; }

        /// <summary>
        /// Gets the ISlackJobs.
        /// </summary>
        public virtual ISlackJobs SlackJobs { get; private set; }

        /// <summary>
        /// Gets the ISlackJob.
        /// </summary>
        public virtual ISlackJob SlackJob { get; private set; }

        /// <summary>
        /// Gets the ISlackPlan.
        /// </summary>
        public virtual ISlackPlan SlackPlan { get; private set; }

        /// <summary>
        /// Gets the ISlackJobsByPlan.
        /// </summary>
        public virtual ISlackJobsByPlan SlackJobsByPlan { get; private set; }

        /// <summary>
        /// Gets the ISlackJobByPlan.
        /// </summary>
        public virtual ISlackJobByPlan SlackJobByPlan { get; private set; }

        /// <summary>
        /// Gets the ISlackPolicy.
        /// </summary>
        public virtual ISlackPolicy SlackPolicy { get; private set; }

        /// <summary>
        /// Gets the IAppProfiles.
        /// </summary>
        public virtual IAppProfiles AppProfiles { get; private set; }

        /// <summary>
        /// Gets the IAccounts.
        /// </summary>
        public virtual IAccounts Accounts { get; private set; }

        /// <summary>
        /// Gets the IDatabases.
        /// </summary>
        public virtual IDatabases Databases { get; private set; }

        /// <summary>
        /// Initializes a new instance of the FLYAPI class.
        /// </summary>
        /// <param name='httpClient'>
        /// HttpClient to be used
        /// </param>
        /// <param name='disposeHttpClient'>
        /// True: will dispose the provided httpClient on calling FLYAPI.Dispose(). False: will not dispose provided httpClient</param>
        protected FLYAPI(HttpClient httpClient, bool disposeHttpClient) : base(httpClient, disposeHttpClient)
        {
            Initialize();
        }

        /// <summary>
        /// Initializes a new instance of the FLYAPI class.
        /// </summary>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        protected FLYAPI(params DelegatingHandler[] handlers) : base(handlers)
        {
            Initialize();
        }

        /// <summary>
        /// Initializes a new instance of the FLYAPI class.
        /// </summary>
        /// <param name='rootHandler'>
        /// Optional. The http client handler used to handle http transport.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        protected FLYAPI(HttpClientHandler rootHandler, params DelegatingHandler[] handlers) : base(rootHandler, handlers)
        {
            Initialize();
        }

        /// <summary>
        /// Initializes a new instance of the FLYAPI class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        protected FLYAPI(System.Uri baseUri, params DelegatingHandler[] handlers) : this(handlers)
        {
            if (baseUri == null)
            {
                throw new System.ArgumentNullException("baseUri");
            }
            BaseUri = baseUri;
        }

        /// <summary>
        /// Initializes a new instance of the FLYAPI class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='rootHandler'>
        /// Optional. The http client handler used to handle http transport.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        protected FLYAPI(System.Uri baseUri, HttpClientHandler rootHandler, params DelegatingHandler[] handlers) : this(rootHandler, handlers)
        {
            if (baseUri == null)
            {
                throw new System.ArgumentNullException("baseUri");
            }
            BaseUri = baseUri;
        }

        /// <summary>
        /// Initializes a new instance of the FLYAPI class.
        /// </summary>
        /// <param name='credentials'>
        /// Required. Subscription credentials which uniquely identify client subscription.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        public FLYAPI(ServiceClientCredentials credentials, params DelegatingHandler[] handlers) : this(handlers)
        {
            if (credentials == null)
            {
                throw new System.ArgumentNullException("credentials");
            }
            Credentials = credentials;
            if (Credentials != null)
            {
                Credentials.InitializeServiceClient(this);
            }
        }

        /// <summary>
        /// Initializes a new instance of the FLYAPI class.
        /// </summary>
        /// <param name='credentials'>
        /// Required. Subscription credentials which uniquely identify client subscription.
        /// </param>
        /// <param name='httpClient'>
        /// HttpClient to be used
        /// </param>
        /// <param name='disposeHttpClient'>
        /// True: will dispose the provided httpClient on calling FLYAPI.Dispose(). False: will not dispose provided httpClient</param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        public FLYAPI(ServiceClientCredentials credentials, HttpClient httpClient, bool disposeHttpClient) : this(httpClient, disposeHttpClient)
        {
            if (credentials == null)
            {
                throw new System.ArgumentNullException("credentials");
            }
            Credentials = credentials;
            if (Credentials != null)
            {
                Credentials.InitializeServiceClient(this);
            }
        }

        /// <summary>
        /// Initializes a new instance of the FLYAPI class.
        /// </summary>
        /// <param name='credentials'>
        /// Required. Subscription credentials which uniquely identify client subscription.
        /// </param>
        /// <param name='rootHandler'>
        /// Optional. The http client handler used to handle http transport.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        public FLYAPI(ServiceClientCredentials credentials, HttpClientHandler rootHandler, params DelegatingHandler[] handlers) : this(rootHandler, handlers)
        {
            if (credentials == null)
            {
                throw new System.ArgumentNullException("credentials");
            }
            Credentials = credentials;
            if (Credentials != null)
            {
                Credentials.InitializeServiceClient(this);
            }
        }

        /// <summary>
        /// Initializes a new instance of the FLYAPI class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='credentials'>
        /// Required. Subscription credentials which uniquely identify client subscription.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        public FLYAPI(System.Uri baseUri, ServiceClientCredentials credentials, params DelegatingHandler[] handlers) : this(handlers)
        {
            if (baseUri == null)
            {
                throw new System.ArgumentNullException("baseUri");
            }
            if (credentials == null)
            {
                throw new System.ArgumentNullException("credentials");
            }
            BaseUri = baseUri;
            Credentials = credentials;
            if (Credentials != null)
            {
                Credentials.InitializeServiceClient(this);
            }
        }

        /// <summary>
        /// Initializes a new instance of the FLYAPI class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='credentials'>
        /// Required. Subscription credentials which uniquely identify client subscription.
        /// </param>
        /// <param name='rootHandler'>
        /// Optional. The http client handler used to handle http transport.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        public FLYAPI(System.Uri baseUri, ServiceClientCredentials credentials, HttpClientHandler rootHandler, params DelegatingHandler[] handlers) : this(rootHandler, handlers)
        {
            if (baseUri == null)
            {
                throw new System.ArgumentNullException("baseUri");
            }
            if (credentials == null)
            {
                throw new System.ArgumentNullException("credentials");
            }
            BaseUri = baseUri;
            Credentials = credentials;
            if (Credentials != null)
            {
                Credentials.InitializeServiceClient(this);
            }
        }

        /// <summary>
        /// An optional partial-method to perform custom initialization.
        ///</summary>
        partial void CustomInitialize();
        /// <summary>
        /// Initializes client properties.
        /// </summary>
        private void Initialize()
        {
            BoxConnection = new BoxConnection(this);
            BoxJobs = new BoxJobs(this);
            BoxJob = new BoxJob(this);
            BoxPlan = new BoxPlan(this);
            BoxJobsByPlan = new BoxJobsByPlan(this);
            BoxJobByPlan = new BoxJobByPlan(this);
            BoxPolicy = new BoxPolicy(this);
            ExchangeConnections = new ExchangeConnections(this);
            ExchangeJobs = new ExchangeJobs(this);
            ExchangeJob = new ExchangeJob(this);
            ExchangePlans = new ExchangePlans(this);
            ExchangePlan = new ExchangePlan(this);
            ExchangeJobsByPlan = new ExchangeJobsByPlan(this);
            ExchangeJobByPlan = new ExchangeJobByPlan(this);
            ExchangePolicies = new ExchangePolicies(this);
            FSConnections = new FSConnections(this);
            FSJobs = new FSJobs(this);
            FSJob = new FSJob(this);
            FSPlans = new FSPlans(this);
            FSPlan = new FSPlan(this);
            FSJobsByPlan = new FSJobsByPlan(this);
            FSJobByPlan = new FSJobByPlan(this);
            FSPolicies = new FSPolicies(this);
            GmailConnection = new GmailConnection(this);
            GmailJobs = new GmailJobs(this);
            GmailJob = new GmailJob(this);
            GmailPlan = new GmailPlan(this);
            GmailJobsByPlan = new GmailJobsByPlan(this);
            GmailJobByPlan = new GmailJobByPlan(this);
            GmailPolicy = new GmailPolicy(this);
            GoogleDriveConnection = new GoogleDriveConnection(this);
            GoogleDriveJobs = new GoogleDriveJobs(this);
            GoogleDriveJob = new GoogleDriveJob(this);
            GoogleDrivePlan = new GoogleDrivePlan(this);
            GoogleDriveJobsByPlan = new GoogleDriveJobsByPlan(this);
            GoogleDriveJobByPlan = new GoogleDriveJobByPlan(this);
            GoogleDrivePolicy = new GoogleDrivePolicy(this);
            IMAPPOP3Jobs = new IMAPPOP3Jobs(this);
            IMAPPOP3Job = new IMAPPOP3Job(this);
            IMAPPOP3Plan = new IMAPPOP3Plan(this);
            IMAPPOP3JobsByPlan = new IMAPPOP3JobsByPlan(this);
            IMAPPOP3JobByPlan = new IMAPPOP3JobByPlan(this);
            IMAPPOP3Policy = new IMAPPOP3Policy(this);
            MicrosoftTeamsConnection = new MicrosoftTeamsConnection(this);
            MicrosoftTeamsJobs = new MicrosoftTeamsJobs(this);
            MicrosoftTeamsJob = new MicrosoftTeamsJob(this);
            MicrosoftTeamsPlan = new MicrosoftTeamsPlan(this);
            MicrosoftTeamsJobsByPlan = new MicrosoftTeamsJobsByPlan(this);
            MicrosoftTeamsJobByPlan = new MicrosoftTeamsJobByPlan(this);
            MicrosoftTeamsPolicy = new MicrosoftTeamsPolicy(this);
            Office365GroupConnection = new Office365GroupConnection(this);
            Office365GroupJobs = new Office365GroupJobs(this);
            Office365GroupJob = new Office365GroupJob(this);
            Office365GroupPlan = new Office365GroupPlan(this);
            Office365GroupJobsByPlan = new Office365GroupJobsByPlan(this);
            Office365GroupJobByPlan = new Office365GroupJobByPlan(this);
            Office365GroupPolicy = new Office365GroupPolicy(this);
            SPJobs = new SPJobs(this);
            SPJob = new SPJob(this);
            SPPlans = new SPPlans(this);
            SPPlan = new SPPlan(this);
            SPJobsByPlan = new SPJobsByPlan(this);
            SPJobByPlan = new SPJobByPlan(this);
            SPPolicies = new SPPolicies(this);
            SlackConnection = new SlackConnection(this);
            SlackJobs = new SlackJobs(this);
            SlackJob = new SlackJob(this);
            SlackPlan = new SlackPlan(this);
            SlackJobsByPlan = new SlackJobsByPlan(this);
            SlackJobByPlan = new SlackJobByPlan(this);
            SlackPolicy = new SlackPolicy(this);
            AppProfiles = new AppProfiles(this);
            Accounts = new Accounts(this);
            Databases = new Databases(this);
            BaseUri = new System.Uri("https://localhost:6010");
            SerializationSettings = new JsonSerializerSettings
            {
                Formatting = Newtonsoft.Json.Formatting.Indented,
                DateFormatHandling = Newtonsoft.Json.DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = Newtonsoft.Json.DateTimeZoneHandling.Utc,
                NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore,
                ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver(),
                Converters = new  List<JsonConverter>
                    {
                        new Iso8601TimeSpanConverter()
                    }
            };
            DeserializationSettings = new JsonSerializerSettings
            {
                DateFormatHandling = Newtonsoft.Json.DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = Newtonsoft.Json.DateTimeZoneHandling.Utc,
                NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore,
                ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver(),
                Converters = new List<JsonConverter>
                    {
                        new Iso8601TimeSpanConverter()
                    }
            };
            CustomInitialize();
        }
    }
}
