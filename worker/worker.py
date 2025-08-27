# GPL-3.0-only
import os, asyncio, httpx

BACKEND = os.getenv("BACKEND_URL", "http://localhost:8000")

async def get_interval():
    async with httpx.AsyncClient() as c:
        r = await c.get(f"{BACKEND}/api/config")
        r.raise_for_status()
        return r.json().get("scheduler_interval_seconds", 60)

async def tick():
    async with httpx.AsyncClient() as c:
        r = await c.post(f"{BACKEND}/api/notifications/cron", params={"mode":"both"})
        r.raise_for_status()
        print("Cron sent:", r.json())

async def main():
    while True:
        try:
            await tick()
            interval = await get_interval()
        except Exception as e:
            print("Worker error:", e)
            interval = 60
        await asyncio.sleep(interval)

if __name__ == "__main__":
    asyncio.run(main())
