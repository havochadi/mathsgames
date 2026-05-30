# mathsgames
Maths games for tutoring

## Cross-device Tracking Setup (GitHub Pages)

This app now supports cloud sync for:
- Session history
- Test attempts
- Tutor PIN
- Student name login
- Global leaderboard (stars + tests + score/time details)

Stars are calculated per test as:
- `stars = round(score × timeMultiplier)`
- `timeMultiplier` increases when the student finishes faster (and is capped to keep scores fair).

### 1) Create Supabase project
- Go to Supabase and create a new project.
- Copy:
  - Project URL (`https://<project-ref>.supabase.co`)
  - API key (anon/publishable key)

### 2) Create table and policies
- Open Supabase SQL Editor.
- Run `supabase_setup.sql`.
- If you already ran an older version before, run the updated SQL again so `student_name` is added.

### 3) Configure the app
- Open `index.html`.
- Find `CLOUD_SYNC` and set:
  - `baseUrl`
  - `apiKey`

### 4) Student Login + Tutor Access
- Students now login/register using their name on the first screen.
- Tutor can open any student profile in: Tutor Dashboard → Settings → `Open Student By Name`.
- Leaderboard is available from Home (`Leaderboard`) and Tutor Settings.

### Notes
- If cloud is not configured or unavailable, the app still works locally.
- Keep student names consistent across devices so tutor lookup matches correctly.
