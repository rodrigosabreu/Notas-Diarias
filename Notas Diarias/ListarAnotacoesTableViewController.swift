//
//  ListarAnotacoesTableViewController.swift
//  Notas Diarias
//
//  Created by Rodrigo Abreu on 13/11/17.
//  Copyright © 2017 Rodrigo Abreu. All rights reserved.
//

import UIKit
import CoreData

class ListarAnotacoesTableViewController: UITableViewController {

    var context: NSManagedObjectContext!
    var anotacoes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recuperAnotacoes()
    }
    
    func recuperAnotacoes(){
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
        let ordernacao = NSSortDescriptor(key: "data", ascending: false)        
        requisicao.sortDescriptors = [ordernacao]
        
        do {
            let anotacoesRecuperadas = try context.fetch(requisicao)
            self.anotacoes = anotacoesRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()            
        } catch let erro  {
            print("Erro ao recuperar anotacoes: \(erro.localizedDescription)")
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return anotacoes.count
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        let anotacao = self.anotacoes[indice]
        self.performSegue(withIdentifier: "verAnotacao", sender: anotacao)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verAnotacao"{
            let viewDestino = segue.destination as! AnotacaoViewController
            viewDestino.anotacao = sender as? NSManagedObject
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        let anotacao = self.anotacoes[ indexPath.row ]
        let textoRecuperado = anotacao.value(forKey: "texto")
        let dataRecuperada = anotacao.value(forKey: "data")
        
        //Formatar data
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy hh:mm"
        
        let novaData = dateFormater.string(from: dataRecuperada as! Date)
        
        celula.textLabel?.text = textoRecuperado as? String
        celula.detailTextLabel?.text = novaData

        return celula
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            let indice = indexPath.row
            let anotacao = self.anotacoes[indice]
            
            self.context.delete(anotacao)//remover do banco utlizando core data
            self.anotacoes.remove(at: indice)//remover do array
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)//remover da tableview
            
            do{
                try self.context.save()
            }catch let erro{
                print("Erro ao remover item \(erro)")
            }
            
        }
        
        
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
