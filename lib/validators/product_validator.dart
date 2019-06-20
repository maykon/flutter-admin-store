class ProductValidators {
  String validateImages(List images) {
    if (images.isEmpty) return "Adicione images ao produto.";
    return null;
  }

  String validateTitle(String text) {
    if (text.isEmpty) return "Preencha o título do produto.";
    return null;
  }

  String validateDescription(String text) {
    if (text.isEmpty) return "Preencha a descrição do produto.";
    return null;
  }

  String validatePrice(String text) {
    if (text.isEmpty) return "Preencha o preço do produto.";
    double price = double.tryParse(text);
    if (price == null) return "Preço do produto é inválido.";
    if (!text.contains(new RegExp(r'^[0-9]+\.[0-9]{2}$')))
      return "Preço deve ter duas casas decimais.";
    return null;
  }

  String validateOptionTitle(String text) {
    if (text.isEmpty) return "Preencha o título das opções.";
    return null;
  }

  String validateOptions(List options) {
    if (options.isEmpty) return "Adicione alguma opção ao produto.";
    return null;
  }

  String validatePrices(List prices) {
    if (prices.isEmpty) return "Adicione algum preço ao produto.";
    return null;
  }

  String validateOptionsItem(String item) {
    if (item.isEmpty) return "Informe a opção do produto.";
    return null;
  }
}
