---
name: flutter-to-native-migration
description: Pixel-perfect migration of Flutter screens to native iOS (SwiftUI) and Android (Jetpack Compose). Use when porting, converting or rewriting Flutter/Dart UI, state or navigation to Swift/SwiftUI or Kotlin/Compose, or when checking parity between a Flutter screen and its native port.
---

# Flutter → native migration

Flutter is the source of truth for **business logic and API contracts**; the design
(Figma) is the source of truth for **UI** when the two disagree. The target project's
own conventions (CLAUDE.md, existing screens, design system) always win over this file.

## Order of work

1. **Analyse fully first** (`flutter-analyst`): resolve every value, state and string.
2. **Port the whole screen 1:1** — app bar, icons, text styles, colors, spacings,
   shadows, borders, bottom-button insets. No "close enough".
3. **Build after each step**, then screenshot and compare side by side.
4. Apply every change to **both platforms in the same pass** unless told otherwise.

## Widget mapping

| Flutter | SwiftUI | Compose |
|---|---|---|
| `Scaffold` + `AppBar` | `NavigationStack` + `.toolbar` / custom bar | `Scaffold(topBar = …)` |
| `Column` / `Row` | `VStack` / `HStack` (`spacing: 0` + explicit spacers) | `Column` / `Row` |
| `Stack` / `Positioned` | `ZStack` / `.offset` / `.overlay(alignment:)` | `Box` / `Modifier.offset` / `align` |
| `Expanded` / `Flexible` | `.frame(maxWidth: .infinity)` / `layoutPriority` | `Modifier.weight(1f)` |
| `SizedBox(h:)` | `Spacer().frame(height:)` | `Spacer(Modifier.height())` |
| `Padding` | `.padding(EdgeInsets)` | `Modifier.padding()` |
| `Container(decoration:)` | `.background` + `.clipShape` + `.overlay(stroke)` + `.shadow` | `Modifier.background(shape).border().shadow()` |
| `ListView.builder` | `ScrollView { LazyVStack }` | `LazyColumn` |
| `RefreshIndicator` | `.refreshable` | `PullToRefreshBox` |
| `showModalBottomSheet` | `.sheet` + content-measured detent | `ModalBottomSheet` (wraps content) |
| `GestureDetector` / `InkWell` | `Button(.plain)` / `.onTapGesture` | `Modifier.clickable` |
| `TextField` | `TextField` / `UIViewRepresentable` for OTP/autofill | `OutlinedTextField` / `BasicTextField` |
| `SvgPicture.asset` | PDF/SVG asset in catalog, `.renderingMode(.template)` if tinted | `ImageVector` / vector drawable |
| `BlocBuilder` / `Cubit` | `@StateObject` store (state + intent) | `ViewModel` + `StateFlow` |
| `BlocListener` (one-shot) | event stream → `.onReceive` | `SharedFlow`/`Channel` → `LaunchedEffect` |
| `Navigator.push` | `NavigationPath` / router | Navigation destination |

## Units and scaling

- Flutter logical px == iOS pt == Android dp. Font `sp` stays `sp` on Android.
- `flutter_screenutil` (`.w/.h/.sp/.r`) values are **scaled** against a design size —
  compute the base value and apply the project's own native scaling helper; never paste
  the unscaled number if the Flutter app scales it.
- Line height: Flutter `height` is a multiplier → iOS `lineSpacing = (h-1) * size`
  (or a custom line-height modifier), Compose `lineHeight = (h * size).sp`.
- Letter spacing in Flutter is absolute px → iOS `.tracking(x)`, Compose `letterSpacing = x.sp`.

## Parity checklist (run on every screen)

- [ ] App bar: title text, alignment, back icon asset, actions, background, divider/shadow
- [ ] Every icon is the exact source asset (not an SF Symbol / Material icon look-alike)
- [ ] Colors use design-system tokens, hex matches
- [ ] Text: font, size, weight, line height, letter spacing, color, max lines, overflow
- [ ] Spacings, paddings, radii, borders, shadows
- [ ] Bottom button: top/bottom/side inset incl. safe area and scaling
- [ ] States: loading (shimmer), empty, error, retry, pull-to-refresh
- [ ] Sheets/modals size to content, never a fixed height guess
- [ ] Strings localized in every supported language
- [ ] Keyboard behaviour, focus order, autofill
- [ ] Dark mode / large text (if the app supports them)
