# Auth Service

The idea is that we create our own user object, auth provider for diffrent authentication providers like email and password, apple, goole etc... and auth service which we will use to do actions like user login or throw exceptions

here's the hierarchy

:::mermaid
    flowchart LR
        Auth_user(("Auth **user**")) -- implements --> Auth_Provider(("Auth 
        **provider**"))
        Auth_Provider -- implements --> Firebase_auth_provider(("**Firebase auth provider**"))
        Auth_service(("Auth service")) -- implements via factory constructor in this project --> Firebase_auth_provider
:::
