# mathsgames
Maths games for tutoring

## Cross-device Tracking Setup (GitHub Pages)

This app now supports cloud sync for:
- Session history
- Test attempts
- Tutor PIN

### 1) Create Supabase project
- Go to Supabase and create a new project.
- Copy:
  - Project URL (`https://<project-ref>.supabase.co`)
  - API key (anon/publishable key)

### 2) Create table and policies
- Open Supabase SQL Editor.
- Run `supabase_setup.sql`.

### 3) Configure the app
- Open `index.html`.
- Find `CLOUD_SYNC` and set:
  - `baseUrl`
  - `apiKey`

### 4) Use same Sync ID on all devices
- In app: Tutor Dashboard → Settings → Cross-Device Sync.
- Enter the same Sync ID on each device.
- Press `Sync Now`.

### Notes
- If cloud is not configured or unavailable, the app still works locally.
- Use long, unique Sync IDs to reduce accidental overlap between students.
