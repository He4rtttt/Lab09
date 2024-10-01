//
//  JuegosViewController.swift
//  ApellidosColeccionDeJuegos
//
//  Created by Kevin Caya Poma on 30/09/24.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row]
    }
    
    
    var imagePicker = UIImagePickerController()
    var juego:Juego? = nil
    
    @IBAction func agregarTapped(_ sender: Any) {
        guard let titulo = tituloTextField.text, !titulo.isEmpty,
                  let imagen = imageView.image else {
                // Mostrar alerta si el título o imagen son inválidos
                let alert = UIAlertController(title: "Error", message: "Por favor, completa todos los campos.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                present(alert, animated: true)
                return
            }

            let categoriaSeleccionada = categorias[categoriaPickerView.selectedRow(inComponent: 0)]
            
            if let juego = juego {
                juego.titulo = titulo
                juego.image = imagen.jpegData(compressionQuality: 0.50)
                juego.categoria = categoriaSeleccionada
            } else {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let nuevoJuego = Juego(context: context)
                nuevoJuego.titulo = titulo
                nuevoJuego.image = imagen.jpegData(compressionQuality: 0.50)
                nuevoJuego.categoria = categoriaSeleccionada
            }
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            navigationController?.popViewController(animated: true)
    }
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Volver a la pantalla anterior
        navigationController?.popViewController(animated: true)
    }
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func camaraTapped(_ sender: Any) {
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    
    @IBOutlet weak var eliminarBoton: UIButton!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageSeleccionada = info[.originalImage] as? UIImage
        imageView.image = imageSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var categoriaPickerView: UIPickerView!
    
    let categorias = ["Acción", "Aventura", "Puzzle", "Deportes", "Estrategia"]
    override func viewDidLoad() {
        super.viewDidLoad()
            imagePicker.delegate = self
            categoriaPickerView.dataSource = self
            categoriaPickerView.delegate = self
            
            if let juego = juego {
                imageView.image = UIImage(data: (juego.image!) as Data)
                tituloTextField.text = juego.titulo
                if let categoria = juego.categoria {
                    if let index = categorias.firstIndex(of: categoria) {
                        categoriaPickerView.selectRow(index, inComponent: 0, animated: false)
                    }
                }
                agregarActualizarBoton.setTitle("Actualizar", for: .normal)
            } else {
                eliminarBoton.isHidden = true
            }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
