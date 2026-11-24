# Fitness — Laborator PAM nr. 4 (varianta 3)

Aplicație Flutter care ia datele dintr-un **serviciu Web REST (HTTP)**, le deserializează din **JSON**
și e organizată după **Clean Architecture** (Presentation / Domain / Data).
Designul este același ca la laboratoarele 2 și 3 (Figma „Laboratoare 2026” → V3).

## Serviciul Web folosit

| Metodă | URL | Ecran |
|---|---|---|
| GET | `https://test-api-jlbn.onrender.com/lab2026/v3/feed` | Home |
| GET | `https://test-api-jlbn.onrender.com/lab2026/v3/feed/details` | Detaliile sălii |

## Cerințele laboratorului și unde sunt implementate

| Cerință | Implementare |
|---|---|
| Servicii Web REST prin HTTP | pachetul `http`; `core/network/api_client.dart` (GET, timeout, verificare cod HTTP) |
| JSON Serialization | `json_serializable`: modelele din `data/models/` au `fromJson` / `toJson` generate în fișierele `*.g.dart` |
| Clean Architecture | straturile `presentation/`, `domain/`, `data/` (vezi mai jos) |
| Operații asincrone | `Future` / `async` / `await` în ApiClient → DataSource → Repository → UseCase → Cubit |
| Stări de încărcare și erori | `LoadStatus` (loading / success / empty / failure) + `Failure` (fără internet, timeout, eroare server, date invalide) și butonul „Try again” |
| Componente UI reutilizabile | `presentation/widgets/` |
| Separarea UI de accesul la date | UI-ul vede doar Cubit-uri; Cubit-urile văd doar use case-uri; doar stratul Data știe de HTTP și JSON |

## Arhitectura

```
lib/
├── main.dart
├── app.dart                         <- pune use case-urile și Cubit-urile globale în arbore
├── injection_container.dart         <- leagă straturile (dependency injection)
├── core/
│   ├── constants/                   <- URL-urile API-ului, pozele și iconițele din Figma
│   ├── error/                       <- exceptions.dart (Data) și failures.dart (Domain)
│   ├── network/                     <- api_client.dart (HTTP + JSON), svg_icon_cache.dart
│   ├── utils/result.dart            <- Result<T>: Success / Failed
│   └── theme/
├── domain/                          <- logica de business, fără Flutter, HTTP sau JSON
│   ├── entities/                    <- HomeFeed, WorkoutProgram, GymDetails...
│   ├── repositories/                <- FitnessRepository (contract / interfață)
│   └── usecases/                    <- GetHomeFeed, GetGymDetails, filter_programs
├── data/                            <- accesul la date
│   ├── models/                      <- DTO-uri @JsonSerializable + toEntity()
│   ├── datasources/                 <- FitnessRemoteDataSource (apelează API-ul)
│   └── repositories/                <- FitnessRepositoryImpl (model → entitate, excepție → Failure, cache)
└── presentation/
    ├── cubits/                      <- HomeCubit, ProgramsCubit, FavoritesCubit, GymDetailsCubit
    ├── screens/                     <- home, programs (See All), plans, gym_details
    └── widgets/                     <- carduri, chip, butoane, inel de progres, stări...
```

Dependențele merg doar spre interior: **Presentation → Domain ← Data**.
Domain nu depinde de nimic; Data implementează interfața din Domain.

## Fluxul datelor (UI → serviciul Web → UI)

1. **UI** — `HomeScreen` pornește; `HomeCubit.load()` emite `loading` → se vede `LoadingView`.
2. **Cubit → UseCase** — `HomeCubit` apelează `GetHomeFeed()`.
3. **UseCase → Repository** — `GetHomeFeed` cere `FitnessRepository.getHomeFeed()` (interfața din Domain).
4. **Repository → DataSource** — `FitnessRepositoryImpl` apelează `FitnessRemoteDataSource.fetchHomeFeed()`.
5. **DataSource → ApiClient → HTTP** — `ApiClient.getJson('/lab2026/v3/feed')` trimite `GET` cu `http`.
6. **Serverul** răspunde cu JSON → `jsonDecode` → `Map`.
7. **Deserializare** — `HomeFeedModel.fromJson(map)` (cod generat de `json_serializable`).
8. **Model → Entitate** — `toEntity()` dă un `HomeFeed` din Domain.
9. **Erori** — excepțiile (`ServerException`, `NetworkException`, `RequestTimeoutException`,
   `ParsingException`) devin `Failure`-uri; repository-ul returnează `Result` (`Success` / `Failed`).
10. **Înapoi în UI** — `HomeCubit` emite `success` (sau `empty` / `failure`) → `BlocBuilder` redesenează ecranul.

La fel pentru pagina de detalii, cu `GetGymDetails` și `/lab2026/v3/feed/details`.

## Funcționalități (păstrate din laboratorul 3)
Căutare, filtrare, sortare, favorite, navigare la detalii, „Read more”, „Reserve”, tragere în jos pentru
reîncărcare de pe server. Răspunsurile sunt ținute în memorie, ca navigarea să nu refacă cererea;
„Try again” și tragerea în jos cer din nou datele de la server.

## Observații
- Serverul gratuit de pe Render „adoarme”: prima cerere poate dura până la ~1 minut (timeout 60 s).
- Serverul nu trimite antete CORS, așa că pe **web** browserul blochează cererea. Aplicația se rulează pe
  **Android / iOS** (emulator sau telefon). Pe Android e adăugată permisiunea `INTERNET`.
- API-ul nu are o categorie pentru programe: un program aparține unui filtru dacă titlul conține numele
  filtrului (ex.: „Cardio Training” → Cardio).
- Pozele și iconițele din Figma sunt asociate după id-ul primit de la API; elementele care nu sunt în
  Figma folosesc imaginea din URL-ul trimis de server.

## Rulare
```
flutter pub get
flutter run
```
Dacă modifici modelele din `data/models/`, regenerează codul de serializare:
```
dart run build_runner build --delete-conflicting-outputs
```

## Teste
```
flutter test
```
35 de teste, fără internet (cu un server HTTP fals, `MockClient`, care răspunde cu JSON-ul real al
API-ului din `test/fixtures/`):
- `data/` — serializare JSON (fromJson / toJson), ApiClient (200, 404, 500, JSON invalid, fără internet,
  timeout), repository (Failure-uri, cache);
- `domain/` — filtrare, căutare, sortare;
- `presentation/` — Cubit-urile (`bloc_test`) și ecranele, inclusiv tot lanțul UI → HTTP → UI.
