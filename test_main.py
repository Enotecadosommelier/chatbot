from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to the Surf Lodge Drink Management API"}

def test_v_fichas_tecnicas_cmv():
    response = client.get("/v_fichas_tecnicas_cmv")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert "nome" in data[0]
    assert "cmv_percent" in data[0]

def test_v_ranking_upselling():
    response = client.get("/v_ranking_upselling")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert "total_vendas_premium" in data[0]

def test_v_evolucao_vendas():
    response = client.get("/v_evolucao_vendas")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert "receita_total" in data[0]
