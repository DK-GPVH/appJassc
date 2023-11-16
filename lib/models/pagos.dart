class Pagos {
  String fecha_pago;
  String descripcion;
  String tipo_pago;
  String estado;
  String monto;

  Pagos(this.fecha_pago, this.descripcion, this.tipo_pago, this.estado,
      this.monto) {
    this.fecha_pago = fecha_pago;
    this.descripcion = descripcion;
    this.tipo_pago = tipo_pago;
    this.estado = estado;
    this.monto = monto;
  }
}
