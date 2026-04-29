# Payment Flow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     SUBSCRIPTION SCREEN                          │
│  - Displays subscription tiers                                   │
│  - User clicks "Unlock Tier" button                             │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                   PAYMENT CONTROLLER                             │
│  createPaymentSession(priceId)                                   │
│  - Sets isLoading = true                                         │
│  - Validates authentication                                      │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                    PAYMENT SERVICE                               │
│  createCheckoutSession()                                         │
│  - Gets token from StorageService                                │
│  - Prepares multipart request                                    │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                   NETWORK CALLER                                 │
│  multipartRequest()                                              │
│  POST /payment/create/                                           │
│  - Headers: Authorization: Bearer {token}                        │
│  - Form Data: price_id, success_url, cancel_url                 │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                  BACKEND API                                     │
│  https://jahidtestmysite.pythonanywhere.com/payment/create/     │
│  - Validates user token                                          │
│  - Creates Stripe checkout session                              │
│  - Returns checkout URL                                          │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                   PAYMENT CONTROLLER                             │
│  - Receives checkout URL                                         │
│  - Sets checkoutUrl observable                                   │
│  - Returns success = true                                        │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                  SUBSCRIPTION SCREEN                             │
│  - Checks if success && checkoutUrl exists                       │
│  - Navigates to PaymentWebViewScreen                            │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│               PAYMENT WEBVIEW SCREEN                             │
│  WebViewController                                               │
│  - Loads Stripe checkout URL                                     │
│  - Shows loading indicator                                       │
│  - Monitors URL changes                                          │
│                                                                   │
│  NavigationDelegate                                              │
│  - onPageStarted: Check URL for completion                       │
│  - onPageFinished: Hide loading                                  │
│  - onWebResourceError: Show error dialog                         │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ├─────────────┬─────────────┬───────────┐
                           ▼             ▼             ▼           ▼
                    ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
                    │ SUCCESS  │  │  CANCEL  │  │  ERROR   │  │   USER   │
                    │ URL      │  │   URL    │  │ OCCURRED │  │ BROWSING │
                    └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────────┘
                         │             │             │
                         ▼             ▼             ▼
                ┌────────────┐  ┌────────────┐  ┌────────────┐
                │Get.back()  │  │Get.back()  │  │Get.back()  │
                │result:     │  │result:     │  │result:     │
                │{success:   │  │{success:   │  │{success:   │
                │ true}      │  │ false,     │  │ false,     │
                │            │  │ cancelled: │  │ error: msg}│
                │+ Success   │  │ true}      │  │            │
                │  Snackbar  │  │            │  │+ Error     │
                │            │  │+ Cancel    │  │  Dialog    │
                │            │  │  Snackbar  │  │            │
                └─────┬──────┘  └─────┬──────┘  └─────┬──────┘
                      │               │               │
                      └───────┬───────┴───────┬───────┘
                              │               │
                              ▼               ▼
                    ┌──────────────────────────────────┐
                    │    SUBSCRIPTION SCREEN           │
                    │  Handle Payment Result           │
                    │                                  │
                    │  If success == true:             │
                    │    - Refresh subscription tiers  │
                    │    - Update UI                   │
                    │                                  │
                    │  If success == false:            │
                    │    - Show error message          │
                    │    - Keep current state          │
                    └──────────────────────────────────┘
```

## State Flow

```
User Action → Controller → Service → API → Service → Controller → UI

State Management (Observables):
┌──────────────────────────────────────────────────────┐
│ PaymentController (GetX)                             │
├──────────────────────────────────────────────────────┤
│ isLoading: RxBool                                    │
│   - false (initial)                                  │
│   - true (during API call)                           │
│   - false (after response)                           │
│                                                       │
│ checkoutUrl: RxString                                │
│   - '' (initial)                                     │
│   - 'https://checkout.stripe.com/...' (on success)   │
│                                                       │
│ errorMessage: RxString                               │
│   - '' (initial/success)                             │
│   - 'Error message' (on failure)                     │
└──────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────┐
│ SubscriptionController (GetX)                        │
├──────────────────────────────────────────────────────┤
│ tiers: RxList<SubscriptionTierModel>                 │
│   - Refreshed after successful payment               │
│                                                       │
│ selectedTierId: RxInt                                │
│   - Updated when user selects tier                   │
│                                                       │
│ isProcessing: RxBool                                 │
│   - Shows loading indicator                          │
└──────────────────────────────────────────────────────┘
```

## Error Handling

```
┌─────────────────────────────────────────────────────┐
│              ERROR SCENARIOS                         │
├─────────────────────────────────────────────────────┤
│ 1. No Authentication Token                          │
│    → Show error: "User not authenticated"           │
│    → Stay on subscription screen                    │
│                                                      │
│ 2. Missing Price ID                                 │
│    → Show error: "Price ID not available"           │
│    → Stay on subscription screen                    │
│                                                      │
│ 3. API Request Failed                               │
│    → Show error from API response                   │
│    → Stay on subscription screen                    │
│                                                      │
│ 4. WebView Load Error                               │
│    → Show error dialog                              │
│    → Return to subscription screen                  │
│                                                      │
│ 5. Network Timeout                                  │
│    → Show error: "Request timeout"                  │
│    → Stay on subscription screen                    │
│                                                      │
│ 6. User Cancels Payment                             │
│    → Show info: "Payment cancelled"                 │
│    → Return to subscription screen                  │
└─────────────────────────────────────────────────────┘
```

## Data Models

```
CreatePaymentRequest
├── priceId: String (Stripe price ID)
├── successUrl: String (completion URL)
└── cancelUrl: String (cancellation URL)

PaymentResponse
├── success: bool (API success flag)
├── message: String (API message)
└── checkoutUrl: String (Stripe URL)

SubscriptionTierModel
├── id: int (UI index)
├── apiId: String (backend ID)
├── name: String
├── features: List<String>
├── priceAmount: double
├── priceCurrency: String
├── priceInterval: String
├── priceIntervalCount: int
├── priceId: String? ← Used for payment
└── trialDays: int?
```
