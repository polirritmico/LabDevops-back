#!/usr/bin/env python
# -*- coding: utf-8 -*-

from datetime import datetime

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root() -> dict[str, str]:
    current_time = datetime.utcnow().strftime("%H:%M:%S")
    return {"data": f"La API funciona correctamente: {current_time} UTC."}


@app.get("/items/{id}")
async def read_id(id: int, q: str | None = None) -> dict[str, str | int]:
    return {"id": id, "q": q}
