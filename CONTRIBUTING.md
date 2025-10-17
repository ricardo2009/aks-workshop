# Guia de Contribuição

Obrigado por considerar contribuir para o **Workshop AKS para Caixa Econômica Federal**! Este documento fornece diretrizes para contribuições ao repositório.

## Como Contribuir

### Reportando Problemas

Se você encontrar um problema ou bug no material do workshop, por favor abra uma **issue** no GitHub incluindo:

- Descrição clara do problema
- Passos para reproduzir (se aplicável)
- Ambiente (versão do AKS, Azure CLI, kubectl, etc.)
- Logs ou mensagens de erro relevantes
- Sugestões de solução (opcional)

### Sugerindo Melhorias

Sugestões de melhorias são bem-vindas! Para propor uma melhoria:

1. Abra uma **issue** descrevendo a melhoria proposta
2. Explique o problema que ela resolve ou o valor que adiciona
3. Forneça exemplos ou referências, se possível
4. Aguarde feedback antes de iniciar o desenvolvimento

### Enviando Pull Requests

Para contribuir com código ou documentação:

1. **Fork** o repositório
2. Crie uma **branch** para sua feature ou correção:
   ```bash
   git checkout -b feature/nome-da-feature
   ```
3. Faça suas alterações seguindo o **Style Guide**
4. **Teste** suas alterações (scripts, manifestos, comandos)
5. **Commit** suas alterações com mensagens claras:
   ```bash
   git commit -m "feat: adiciona cenário de troubleshooting para PVC"
   ```
6. **Push** para sua branch:
   ```bash
   git push origin feature/nome-da-feature
   ```
7. Abra um **Pull Request** descrevendo suas alterações

### Padrões de Commit

Utilizamos o padrão **Conventional Commits**:

- `feat:` - Nova funcionalidade ou conteúdo
- `fix:` - Correção de bug ou erro
- `docs:` - Alterações apenas em documentação
- `refactor:` - Refatoração de código ou estrutura
- `test:` - Adição ou correção de testes
- `chore:` - Tarefas de manutenção

Exemplos:
```
feat: adiciona lab de Azure Key Vault CSI Driver
fix: corrige comando kubectl no cenário de DNS
docs: atualiza README com novos pré-requisitos
refactor: reorganiza estrutura de diretórios
```

## Padrões de Qualidade

### Documentação

- Use **Markdown** para toda documentação
- Siga a estrutura existente dos arquivos
- Inclua **diagramas Mermaid** para fluxos e arquiteturas
- Adicione **exemplos práticos** com comandos e outputs esperados
- Referencie **documentação oficial** da Microsoft/Azure
- Mantenha arquivos com **máximo 300 linhas** (divida se necessário)

### Scripts

- Use **Bash** para scripts de automação
- Adicione **comentários** explicativos
- Valide **pré-requisitos** no início do script
- Inclua **mensagens de progresso** claras
- Trate **erros** adequadamente
- Torne scripts **idempotentes** (executáveis múltiplas vezes)

### Manifestos Kubernetes

- Use **YAML** válido e bem formatado
- Adicione **comentários** para configurações importantes
- Inclua **labels** e **annotations** apropriadas
- Siga **best practices** do Kubernetes
- Valide com `kubectl apply --dry-run=client`

### Diagramas

- Use **Mermaid** para todos os diagramas
- Mantenha **clareza** e **simplicidade**
- Adicione **legendas** quando necessário
- Use **cores consistentes** com o tema do repositório

## Estrutura de Arquivos

Ao adicionar novos arquivos, siga a estrutura existente:

```
aks-workshop/
├── labs/                    # Laboratórios hands-on
├── troubleshooting/         # Cenários de troubleshooting
├── monitoramento/           # Monitoramento e observabilidade
├── arquitetura/             # Documentação arquitetural
├── diagrams/                # Diagramas Mermaid
├── scripts/                 # Scripts utilitários
├── dashboards-alerts/       # Dashboards e alertas
└── ...
```

## Nomenclatura

- **Arquivos:** Use `kebab-case` (ex: `dns-failure.md`)
- **Diretórios:** Use `kebab-case` (ex: `troubleshooting/`)
- **Variáveis em scripts:** Use `UPPER_CASE` para constantes, `snake_case` para variáveis
- **Recursos Kubernetes:** Use `kebab-case` (ex: `nginx-deployment`)

## Testando Suas Alterações

Antes de enviar um Pull Request:

1. **Valide Markdown:**
   ```bash
   # Use um linter de Markdown
   markdownlint *.md
   ```

2. **Teste scripts:**
   ```bash
   # Execute em ambiente de teste
   bash script.sh
   ```

3. **Valide YAML:**
   ```bash
   kubectl apply --dry-run=client -f manifest.yaml
   ```

4. **Verifique diagramas Mermaid:**
   - Use [Mermaid Live Editor](https://mermaid.live/)

## Revisão de Código

Todos os Pull Requests passarão por revisão. O revisor verificará:

- Aderência ao **Style Guide**
- **Qualidade técnica** do conteúdo
- **Clareza** da documentação
- **Funcionamento** de scripts e manifestos
- **Consistência** com o resto do repositório

## Código de Conduta

Este projeto adota um código de conduta baseado em respeito e colaboração:

- Seja **respeitoso** com outros contribuidores
- Aceite **críticas construtivas**
- Foque no que é **melhor para o projeto**
- Mostre **empatia** com outros membros da comunidade

## Dúvidas?

Se tiver dúvidas sobre como contribuir, abra uma **issue** ou entre em contato com os mantenedores do projeto.

---

**Obrigado por contribuir para tornar este workshop ainda melhor!** 🚀

