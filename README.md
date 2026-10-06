# Fitness — Laborator PAM nr. 3 (varianta 3)

Aplicație Flutter cu **State Management (BLoC / Cubit)** și **programare asincronă**.
Datele sunt în fișierul JSON inclus în proiect (`assets/data/lab_v3.json`) și se încarcă asincron.
Designul este cel din Figma „Laboratoare 2026” → pagina **V3** (ecranele `21. Home v2` și `30. Fitness`).

## Cerințele laboratorului și unde sunt implementate

| Cerință | Implementare |
|---|---|
| Package de state management | `flutter_bloc` — Cubit-uri în `lib/logic/` |
| Date într-un fișier JSON inclus în proiect | `assets/data/lab_v3.json` |
| Încărcare asincronă | `FitnessRepository` (`Future`, `async/await`, `rootBundle.loadString`, `jsonDecode`) |
| Modelarea datelor | `lib/data/models/` — clase cu `fromJson` și `Equatable` |
| Stările Loading / Success / Empty / Error | `LoadStatus` + `LoadingView` / `MessageView.empty` / `MessageView.error` (cu „Try again”) |
| Listă de elemente | Featured Plans, Workout Programs (grilă) |
| Căutare | ecranul „Workout Programs → See All” (`SearchField`) |
| Filtrare | chip-urile All Type / Pilates / Cardio / Boxing / Yoga (pe Home și pe See All) |
| Sortare | meniul „Sort”: Recommended, Name A–Z, Name Z–A, Calories, Duration |
| Favorite (adăugare / eliminare) | inima de pe carduri + filtrul „doar favorite” (`FavoritesCubit`) |
| Navigare către pagina de detalii | Start Now / tap pe program → pagina sălii (`GymDetailsScreen`) |
| Componente UI reutilizabile | `lib/presentation/widgets/` |

## Arhitectura

```
lib/
├── main.dart
├── app.dart                       <- RepositoryProvider + BlocProvider-e globale
├── core/
│   ├── constants/app_icons.dart   <- iconițele SVG din Figma (rezervă)
│   └── theme/                     <- culori și stiluri text din Figma
├── data/
│   ├── models/                    <- home_models.dart, gym_models.dart
│   └── repositories/              <- fitness_repository.dart, svg_icon_cache.dart
├── logic/                         <- State management (Cubit + State)
│   ├── load_status.dart           <- initial / loading / success / empty / failure
│   ├── home/                      <- HomeCubit: încărcare, filtru, challenge
│   ├── programs/                  <- ProgramsCubit: căutare, filtru, sortare, favorite
│   ├── favorites/                 <- FavoritesCubit: id-urile favorite (global)
│   └── gym/                       <- GymDetailsCubit: detalii, Read more, Reserve
└── presentation/
    ├── navigation.dart
    ├── screens/                   <- home, programs (See All), plans, gym_details
    └── widgets/                   <- carduri, chip, butoane, inel progres, stări etc.
```

Fluxul datelor: **JSON → FitnessRepository (async) → Cubit → State → BlocBuilder → UI**.

## Ecranele
- **Home** — data și salutul din JSON, notificări, „Today’s Challenge” (15/20, crește la apăsare),
  Featured Plan (listă orizontală), Workout Programs cu filtre. Tragere în jos = reîncărcare.
- **Workout Programs (See All)** — căutare, filtre, sortare, favorite, număr de rezultate, stare goală cu „Clear filters”.
- **Featured Plans (See All)** — toate planurile.
- **Detalii sală** (a doua pagină, după JSON) — imagine, rating 4.5 (1,232 reviews), descriere cu Read more,
  Amenities (Showers, Lockers), Total $69.00 /week și butonul Reserve.

## Observații
- Imaginile și iconițele vin din URL-urile din JSON (Unsplash, Iconify). Fără internet, imaginile arată un
  placeholder, iar iconițele trec automat pe iconițele locale exportate din Figma.
- JSON-ul nu are câmp de categorie pentru programe, așa că un program aparține unui filtru dacă titlul
  conține numele filtrului (ex.: „Cardio Training” → Cardio). Pilates și Boxing nu au programe → se vede starea Empty.
- `FitnessRepository` are o întârziere de 0,8 s ca să se vadă starea Loading.

## Rulare
```
flutter pub get
flutter run
```

## Teste
```
flutter test
```
Teste pentru: citirea JSON-ului, filtrare/căutare/sortare, toate Cubit-urile (`bloc_test`,
inclusiv stările Loading/Success/Empty/Error) și fluxurile din interfață.
