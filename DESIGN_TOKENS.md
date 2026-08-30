# Satpamku — Design Tokens Specification (Frozen)

This document freezes the design system tokens for **Satpamku** derived from the approved Google Stitch designs. These tokens must be strictly used across Flutter Material 3 theme generation and backend CMS composition.

---

## 1. Brand Essence & Theme Identity
- **Personality**: Professional, Disciplined, Trustworthy, Modern Corporate, Authoritative yet Accessible.
- **Visual Structure**: Structured card-based layouts, 8dp baseline grid, tonal surface elevation over heavy dropshadows, high contrast scannability for security credentials, salary, and shift metadata.

---

## 2. Color Tokens (`AppColors`)

### 2.1 Core Brand Palette
| Token Name | Hex Code | Flutter Value | Role & Usage |
| :--- | :--- | :--- | :--- |
| `primary` | `#000666` | `Color(0xFF000666)` | Deep Navy. Brand mark, primary action buttons, key headers. |
| `primaryContainer` | `#1A237E` | `Color(0xFF1A237E)` | Deep Royal Navy. Active navigation pills, prominent container badges. |
| `onPrimary` | `#FFFFFF` | `Color(0xFFFFFFFF)` | White. Text/icons on primary surfaces. |
| `onPrimaryContainer` | `#8690EE` | `Color(0xFF8690EE)` | Light Slate Blue. Subdued text/icons on primary containers. |
| `primaryFixed` | `#E0E0FF` | `Color(0xFFE0E0FF)` | Soft Navy Tint. Hover states, category icon background tints. |
| `primaryFixedDim` | `#BDC2FF` | `Color(0xFFBDC2FF)` | Light periwinkle for dark mode headers and subtle borders. |
| `secondary` | `#775A19` | `Color(0xFF775A19)` | Brass Gold Dark. Merit text, secondary headers. |
| `secondaryContainer` | `#FED488` | `Color(0xFFFED488)` | Warm Brass Gold Tint. Active drawer/tab pill background. |
| `onSecondaryContainer` | `#785A1A` | `Color(0xFF785A1A)` | Brass Gold Deep. Text on secondary containers. |
| `brassGold` | `#C5A059` | `Color(0xFFC5A059)` | Metallic Brass Gold. Verification badges, certification stars, VIP category. |
| `secondaryFixed` | `#FFDEA5` | `Color(0xFFFFDEA5)` | Light Golden Amber. Highlight cards, training banner chips. |
| `onSecondaryFixed` | `#261900` | `Color(0xFF261900)` | Dark amber text on secondary fixed badges. |

### 2.2 Semantic & Status Colors
| Token Name | Hex Code | Flutter Value | Role & Usage |
| :--- | :--- | :--- | :--- |
| `successGreen` / `tertiary` | `#2E7D32` | `Color(0xFF2E7D32)` | Forest/Success Green. Verified status, hired stage, salary text. |
| `tertiaryContainer` | `#003909` | `Color(0xFF003909)` | Dark green container background. |
| `onTertiaryContainer` | `#5AA958` | `Color(0xFF5AA958)` | Vibrant light green on dark green container. |
| `tertiaryFixed` | `#A3F69C` | `Color(0xFFA3F69C)` | Pale Mint Green. Verified candidate pill background. |
| `onTertiaryFixedVariant`| `#005312` | `Color(0xFF005312)` | Dark Green. Text on verified candidate pills. |
| `errorRed` / `error` | `#BA1A1A` | `Color(0xFFBA1A1A)` | Urgent badges, rejection status, destructive actions. |
| `errorContainer` | `#FFDAD6` | `Color(0xFFFFDAD6)` | Pale Red. Urgent hiring tag container background. |
| `onErrorContainer` | `#93000A` | `Color(0xFF93000A)` | Deep Red. Text/icon on urgent hiring tags. |

### 2.3 Surface & Neutral Gradients
| Token Name | Hex Code | Flutter Value | Role & Usage |
| :--- | :--- | :--- | :--- |
| `surface` / `background` | `#F8F9FA` | `Color(0xFFF8F9FA)` | Level 0 Canvas. Anti-glare cool off-white app background. |
| `surfaceContainerLowest`| `#FFFFFF` | `Color(0xFFFFFFFF)` | Level 1 Surface. Pure white cards, search inputs, dialogs. |
| `surfaceContainerLow` | `#F3F4F5` | `Color(0xFFF3F4F5)` | Subtle contrast card sections, category button backgrounds. |
| `surfaceContainer` | `#EDEEEF` | `Color(0xFFEDEEEF)` | Metadata chip backgrounds, logo container borders. |
| `surfaceContainerHigh` | `#E7E8E9` | `Color(0xFFE7E8E9)` | Filter pill hover, trailing button backgrounds. |
| `surfaceContainerHighest`| `#E1E3E4`| `Color(0xFFE1E3E4)` | Progress bar background tracks, inactive chips. |
| `onSurface` | `#191C1D` | `Color(0xFF191C1D)` | Primary high-emphasis body and title text. |
| `onSurfaceVariant` | `#454652` | `Color(0xFF454652)` | Medium-emphasis text, secondary descriptors. |
| `slateGray` | `#455A64` | `Color(0xFF455A64)` | Metadata icons, subtitle copy, company industry text. |
| `inkBlack` | `#121212` | `Color(0xFF121212)` | Deepest neutral for strong contrast headings. |
| `outline` | `#767683` | `Color(0xFF767683)` | Form field borders (idle), default divider lines. |
| `outlineVariant` | `#C6C5D4` | `Color(0xFFC6C5D4)` | Subtle dividers, card borders, scrollbar tracks. |

---

## 3. Typography Tokens (`AppTypography`)

Primary Font Family: **`Hanken Grotesk`** across all platforms.

| Scale Token | Font Size | Line Height | Weight | Letter Spacing | Flutter `TextStyle` |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `headlineLg` | 32.0 | 40.0 | Bold (700) | -0.5 | `TextStyle(fontSize: 32, height: 40/32, fontWeight: FontWeight.w700, letterSpacing: -0.5)` |
| `headlineLgMobile`| 26.0 | 32.0 | Bold (700) | 0.0 | `TextStyle(fontSize: 26, height: 32/26, fontWeight: FontWeight.w700)` |
| `headlineMd` | 24.0 | 32.0 | SemiBold (600)| 0.0 | `TextStyle(fontSize: 24, height: 32/24, fontWeight: FontWeight.w600)` |
| `headlineSm` | 20.0 | 28.0 | SemiBold (600)| 0.0 | `TextStyle(fontSize: 20, height: 28/20, fontWeight: FontWeight.w600)` |
| `titleMd` | 16.0 | 24.0 | SemiBold (600)| 0.0 | `TextStyle(fontSize: 16, height: 24/16, fontWeight: FontWeight.w600)` |
| `bodyLg` | 16.0 | 24.0 | Regular (400) | 0.0 | `TextStyle(fontSize: 16, height: 24/16, fontWeight: FontWeight.w400)` |
| `bodyMd` | 14.0 | 20.0 | Regular (400) | 0.0 | `TextStyle(fontSize: 14, height: 20/14, fontWeight: FontWeight.w400)` |
| `labelLg` | 12.0 | 16.0 | SemiBold (600)| +0.5 | `TextStyle(fontSize: 12, height: 16/12, fontWeight: FontWeight.w600, letterSpacing: 0.5)` |
| `labelSm` | 11.0 | 14.0 | Medium (500) | 0.0 | `TextStyle(fontSize: 11, height: 14/11, fontWeight: FontWeight.w500)` |

---

## 4. Spacing & Grid Tokens (`AppSpacing`)

Based on strict **8dp Baseline Grid**:
- `unit`: `8.0` dp
- `stackSm`: `4.0` dp (micro-spacing between icon and chip text)
- `stackMd`: `12.0` dp (spacing between card content groups)
- `stackLg`: `24.0` dp (vertical rhythm between section blocks)
- `cardPadding`: `16.0` dp (internal card padding)
- `gutter`: `16.0` dp (horizontal gutter between grid items)
- `marginMobile`: `16.0` dp (safe left/right screen padding on mobile)
- `marginTablet`: `24.0` dp (safe left/right padding on tablet/web canvas)

---

## 5. Shape & Corner Radii (`AppRadius`)

Adhering to the **Soft Disciplined Persona** (avoiding overly playful bubble shapes):
- `radiusSm`: `2.0` dp (`BorderRadius.circular(2.0)`)
- `radiusDefault`: `4.0` dp (`BorderRadius.circular(4.0)`) — Buttons, textfields, status chips.
- `radiusMd`: `6.0` dp (`BorderRadius.circular(6.0)`) — Inner badges, small thumbnail frames.
- `radiusLg`: `8.0` dp (`BorderRadius.circular(8.0)`) — Standard job cards, company cards.
- `radiusXl`: `12.0` dp (`BorderRadius.circular(12.0)`) — Bento grid containers, category icons, bottom sheets.
- `radiusFull`: `9999.0` dp (`BorderRadius.circular(9999.0)`) — Circular user avatars, navigation tab active pills.

---

## 6. Elevation & Shadows (`AppElevation`)

- **Level 0 (Canvas)**: No shadow (`BoxShadow` none). Background color `#F8F9FA`.
- **Level 1 (Card / Surface)**:
  `BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2), spreadRadius: 0)`
- **Level 2 (Dropdown / Floating Header)**:
  `BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4), spreadRadius: 0)`
- **Level 3 (Modal BottomSheet / Side Drawer)**:
  `BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, -4), spreadRadius: 0)`

---

## 7. Motion & Animation Tokens (`AppMotion`)

- `durationFast`: `150ms` — Button press scale, active tab switch, toggle animations.
- `durationMedium`: `250ms` — BottomSheet open/close, card expansion, dialog fade.
- `durationSlow`: `350ms` — Screen page route transitions, hero animations.
- `curveStandard`: `Curves.easeInOut`
- `curveDecelerate`: `Curves.fastOutSlowIn`
- `scaleActive`: `0.95` (Subtle tactile feedback on tap down)

---

## 8. Material 3 `ThemeData` Blueprint (Flutter)

```dart
import 'package:flutter/material.dart';

class SatpamkuTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Hanken Grotesk',
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF000666),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFF1A237E),
        onPrimaryContainer: Color(0xFF8690EE),
        secondary: Color(0xFF775A19),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFFED488),
        onSecondaryContainer: Color(0xFF785A1A),
        tertiary: Color(0xFF2E7D32),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFA3F69C),
        onTertiaryContainer: Color(0xFF005312),
        error: Color(0xFFBA1A1A),
        onError: Color(0xFFFFFFFF),
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF93000A),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF191C1D),
        onSurfaceVariant: Color(0xFF454652),
        outline: Color(0xFF767683),
        outlineVariant: Color(0xFFC6C5D4),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8F9FA),
        foregroundColor: Color(0xFF000666),
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1.0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFFFFFFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: Color(0xFFC6C5D4), width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: const Color(0xFFFFFFFF),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Hanken Grotesk',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF000666),
          side: const BorderSide(color: Color(0xFF000666), width: 1.5),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Hanken Grotesk',
          ),
        ),
      ),
    );
  }
}
```
