# Tech-lead playbook

## Əsas fikir

Senior engineer özü yazır. Tech lead **işi bölür, düzgün adama verir, nəticəni yoxlayır,
qərar verir**. Claude Code-da "adamlar" bunlardır:

| "Komanda üzvü" | Claude Code-da | Nə vaxt |
|---|---|---|
| Ayrı developer | **Session** (öz worktree-si ilə) | Öz branch/MR-ı olan müstəqil iş |
| Kömək edən həmkar | **Subagent** | Nəticəsi sənə indi lazım olan iş: axtarış, analiz, review, QA |
| Sən | **Baş session** | Plan, brief, review qərarları, təsdiq |

Bunlar Claude Code-un öz funksiyalarıdır (CLI, desktop app, web) — bu plugin onlara
hazır **rollar, komandalar və qaydalar** əlavə edir.

## Qərar ağacı

```
Bu iş öz commit/MR-ı ilə ayrıca bitəcək və başqa hissələrdən asılı deyil?
├─ Bəli → başqa hissə ilə eyni fayllara toxunur?
│   ├─ Bəli → ardıcıl et (və ya ayrı worktree-lərdə, sonra merge)
│   └─ Xeyr → AYRI SESSION + WORKTREE
└─ Xeyr → nəticəsi mənə indi lazımdır (axtarış/analiz/review/QA)?
    ├─ Bəli → SUBAGENT
    └─ Xeyr / bir neçə tool call-luq iş → BURADA ET
```

## Tipik ssenari: bir ekranı iOS + Android-ə köçürmək

```
/migrate-screen lib/features/order/order_confirmation_page.dart both
```

1. `flutter-analyst` → `docs/migration-specs/order-confirmation.md` (hər iki porter eyni sənəddən oxuyur)
2. Açıq suallar varsa — sən cavab verirsən
3. iOS porter ‖ Android porter — paralel, ayrı repo/worktree
4. `reviewer` × 2 (platforma üzrə) + 1 (parity)
5. `qa-verifier` × 2 — screenshot müqayisəsi
6. Fix loop — tapıntı faylın sahibi olan porter-ə qayıdır (yeni session yox)
7. Status board → sən commit/MR qərarı verirsən

## Yaxşı brief necə olur

Pis:
> Android tərəfini də et, yuxarıda tapdıqlarımıza əsasən.

Yaxşı:
> **Məqsəd:** `docs/migration-specs/order-confirmation.md` spec-ini Android Compose-da 1:1 implement et.
> **Harada:** `android/feature/order/` — mövcud `OrderListScreen.kt`-ı nümunə götür.
> **Qaydalar:** əvvəl `CLAUDE.md`-ni oxu; design system komponentlərindən istifadə et; string-lər localization-dan.
> **Toxunma:** `core/network`, iOS qovluğu. Commit etmə.
> **Bitdi sayılır:** `./gradlew assembleDebug` keçir; spec-dəki 4 state implement olunub; hesabatda dəyişən fayllar + implement olunmayan bəndlər.

## Status board

Hər addımdan sonra Claude belə hesabat verir:

```
developer   iOS order confirmation      DONE      feature/ios-order-confirm
migration   Android order confirmation  RUNNING   worktree · 14 files
qa          iOS                         BLOCKED   real cihazda test — təsdiqini gözləyir
reviewer    iOS                         DONE      3 findings to read
```

## Qızıl qaydalar

1. **Analiz əvvəl, kod sonra.** Spec olmadan porter başlamır.
2. **İki writer eyni fayla toxunmur.**
3. **Review-ə kodu ver, öz fikrini yox** — yoxsa review sənin fikrini təsdiqləyir.
4. **Worker-in hesabatı iddiadır, sübut deyil** — diff-ə və build-ə özün bax.
5. **Geri dönməz addımlar (commit, push, merge, publish, real ödəniş/data) — yalnız sənin "bəli"nlə.**
6. **Şübhədə qalanda spawn etmə.** Hər agent token xərcidir; kiçik işi özün et.
