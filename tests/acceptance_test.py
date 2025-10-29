#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fastapi.testclient import TestClient

from src.main import app

client = TestClient(app)


def test_root_endpoint():
    case = "/"
    expected_key = "data"
    expected_value = "La API funciona correctamente"

    response = client.get(case)
    assert response.status_code == 200
    output = response.json()

    assert expected_value in output.get(expected_key)


def test_read_items():
    case = "/items/42?q=answer"
    expected_id = 42
    expected_q = "answer"

    response = client.get(case)
    assert response.status_code == 200
    output = response.json()

    assert expected_id == output.get("id")
    assert expected_q == output.get("q")
