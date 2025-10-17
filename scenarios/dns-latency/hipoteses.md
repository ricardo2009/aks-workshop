# Hipóteses Investigadas

1. **Exaustão de CPU nos pods CoreDNS** provocando fila de resolução.
2. **Loop de DNS** causado por `stubDomains` apontando para IP incorreto.
3. **Problema externo** no resolver corporativo (conditional forwarding).
4. **Saturação de IPs** causando quedas intermitentes de pods CoreDNS.
