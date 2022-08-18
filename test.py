
from decimal import Decimal

PI = Decimal('3.14159265358979323846264338327950288')
RE = Decimal(6378.137)
RAD = PI / Decimal(180.0)
print(Decimal(1.0) / (RAD * RE * Decimal(1000)))