import pytest
import calculator_func

def test_add():
    assert calculator_func.add(10,15) == 25, "You have an issue in addition function"
    assert calculator_func.add(2, 5) == 7, "You have an issue in addition function"
    assert calculator_func.add(9, 10) == 19, "You have an issue in addition function"
    assert calculator_func.add(8, 8) == 16, "You have an issue in addition function"

def test_subtract():
    assert calculator_func.subtract(15, 10) == 5, "You have an issue in subtract function"
    assert calculator_func.subtract(16, 8) == 8, "You have an issue in subtract function"
    assert calculator_func.subtract(20, 5) == 15, "You have an issue in subtract function"
    assert calculator_func.subtract(9, 9) == 0, "You have an issue in subtract function"

def test_multiply():
    assert calculator_func.multiply(5, 5) == 25, "You have an issue in multiply function"
    assert calculator_func.multiply(8, 4) == 24, "You have an issue in multiply function"
    assert calculator_func.multiply(2, 4) == 8, "You have an issue in multiply function"
    assert calculator_func.multiply(1, 1) == 1, "You have an issue in multiply function"

def test_divide():
    assert calculator_func.divide(30, 6) == 5, "You have an issue in divide function"
    assert calculator_func.divide(48, 12) == 4, "You have an issue in divide function"
    assert calculator_func.divide(6, 2) == 3, "You have an issue in divide function"
    assert calculator_func.divide(84, 7) == 12, "You have an issue in divide function"
    assert calculator_func.divide(9, 0) == "Division by zero exception", "You have an issue in division function"
    assert calculator_func.divide(0, 2) == "Division by zero exception", "You have an issue in division function"
