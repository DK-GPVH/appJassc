class ListPropiedad {
  String id;
  String manzana;
  String lote;
  String zona;
  String nrodesuministro;
  String cliente_id;
  String categoria_id;
  String estado;
  String fechains;
  String fechaadeudo;

  ListPropiedad(
      this.id,
      this.manzana,
      this.lote,
      this.zona,
      this.nrodesuministro,
      this.cliente_id,
      this.categoria_id,
      this.estado,
      this.fechains,
      this.fechaadeudo) {
    this.id = id;
    this.manzana = manzana;
    this.lote = lote;
    this.zona = zona;
    this.nrodesuministro = nrodesuministro;
    this.cliente_id = cliente_id;
    this.categoria_id = categoria_id;
    this.estado = estado;
    this.fechains = fechains;
    this.fechaadeudo = fechaadeudo;
  }
}
