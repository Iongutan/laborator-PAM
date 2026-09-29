# Fitness — Laborator PAM (design Figma, varianta 3)

Aplicație Flutter care implementează designul din Figma
**„Laboratoare 2026” → pagina V3**, cu ambele ecrane:

| Ecran Figma | Fișier |
|---|---|
| `21. Home v2` | `lib/screens/home_screen.dart` |
| `30. Fitness` | `lib/screens/gym_detail_screen.dart` |

## Ce conține fiecare ecran

**Home**
- Data curentă („Friday, 20 May”) și salut în funcție de oră (Good Morning / Afternoon / Evening).
- Butonul de notificări (clopoțel cu punct roșu).
- Cardul „Today’s Challenge — Running” cu inel de progres animat (15/20); la apăsare progresul crește.
- „Featured Plan”: listă orizontală de carduri cu imagine, „5 week • 4x/week” și butonul **Start Now**.
- „Workout Programs”: chip-uri de filtrare (All Type, Pilates, Cardio, Boxing, Yoga) și grila de programe
  (Yoga, Arm Strengthening cu insigna **Pro**), cu kcal și minute.

**Fitness (detalii sală)** — se deschide din **Start Now** sau apăsând un program
- Imagine mare, buton înapoi semitransparent și meniul „⋮”.
- Rating 4.5 (1,232 reviews), „Mid City Gym Training”, „California, New York”.
- Descriere cu **Read more / Show less**.
- „Amenities”: Showers, Lockers, Free Wi-fi.
- Bara de jos: Total **$69.00 /week** și butonul **Reserve** (comută în „Reserved”).

## Detalii de design respectate
- Font **Plus Jakarta Sans** (Regular/Medium/SemiBold/Bold), inclus în `assets/fonts` (licență OFL).
- Culorile din Figma în `lib/theme/app_colors.dart` (Primary `#22C55E`, Greyscale `#0D0D12`, `#818898`, `#DFE1E7` etc.).
- Stilurile de text (H4, H6, Body…) în `lib/theme/app_text_styles.dart`, inclusiv letter-spacing -2%.
- Iconițele sunt SVG-urile exportate direct din Figma (`assets/icons`), afișate cu `flutter_svg`.
- Fotografiile sunt cele originale din Figma (`assets/images`), încadrate la fel ca în design.
- Dimensiuni, spațieri și raze de colț luate din Figma (padding 24, carduri 296×144 și 184, raze 12/8/6).

## Structura proiectului
```
lib/
├── main.dart                  <- aplicația + temă
├── models/fitness_data.dart   <- modele și datele afișate
├── screens/
│   ├── home_screen.dart
│   └── gym_detail_screen.dart
├── theme/
│   ├── app_colors.dart
│   └── app_text_styles.dart
└── widgets/                   <- componente reutilizabile (carduri, chip, butoane, inel progres)
assets/
├── fonts/  icons/  images/
test/
└── widget_test.dart           <- teste pentru ecrane și interacțiuni
```

## Cum rulezi proiectul
1. Deschide folderul în Android Studio / VS Code.
2. `flutter pub get`
3. Pornește un emulator sau conectează un telefon și apasă **Run** (▶), sau `flutter run`.

Teste: `flutter test`
