import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var juegos: [Juego] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = false // Deshabilitar la edición inicialmente
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    
    func loadData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            juegos = try context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        } catch {
            print("Error al cargar datos: \(error)")
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            let juego = juegos[indexPath.row]
            cell.textLabel?.text = juego.titulo
            cell.detailTextLabel?.text = "Categoría: \(juego.categoria ?? "Sin categoría")"
            cell.imageView?.image = UIImage(data: (juego.image!))
            return cell
    }

    // Habilitar la opción de editar (eliminar) la celda
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete // Habilita la opción de eliminar
    }
    
    


    // Manejar la eliminación de la celda
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(juegos[indexPath.row]) // Eliminar el juego de la lista
            do {
                try context.save() // Guardar cambios
                juegos.remove(at: indexPath.row) // Eliminar el juego de la matriz
                tableView.deleteRows(at: [indexPath], with: .fade) // Eliminar la fila de la tabla
            } catch {
                print("Error al eliminar: \(error)")
            }
        }
    }

    // Habilitar el movimiento de las celdas
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true // Permitir que se muevan
    }

    // Manejar el movimiento de las celdas
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let movedJuego = juegos.remove(at: fromIndexPath.row)
        juegos.insert(movedJuego, at: toIndexPath.row)
        tableView.reloadData()
    }


    // Alternar entre modo de edición y no edición
    @IBAction func editarTapped(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle() // Cambiar el estado de edición
        sender.title = tableView.isEditing ? "Listo" : "Editar" // Cambiar el texto del botón
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
}

