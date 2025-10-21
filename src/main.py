#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root() -> dict[str, str]:
    return {"data": "La API funciona correctamente y devuelve este mensaje."}


@app.get("/items/{id}")
async def read_id(id: int, q: str | None = None) -> dict[str, str | int]:
    return {"id": id, "q": q}
