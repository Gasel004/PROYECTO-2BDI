import { query } from '../../lib/db.js';

export async function GET() {
  try {
    await query('SELECT 1');
    return Response.json({ estado: 'ok' });
  } catch {
    return Response.json({ estado: 'sin conexión a la base de datos' }, { status: 503 });
  }
}
