//
//  ViewController.swift
//  Alarm
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var alarmLabel: UILabel!
    
    @IBOutlet var scheduleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        NotificationCenter.default.addObserver(self, selector:
                                                #selector(updateUI), name: .alarmUpdated, object: nil)
        
    }
    
    @objc func updateUI() {
        if let scheduledAlarm = Alarm.scheduled {
            let fomattedAlarm = scheduledAlarm.date.formatted(.dateTime.day(.defaultDigits).month(.defaultDigits).year(.twoDigits).hour().minute())
            alarmLabel.text = "Tu alarma está programada para las \(fomattedAlarm)"
            datePicker.isEnabled = false
            scheduleButton.setTitle("Borrar Alarma", for: .normal)
        } else {
            alarmLabel.text = "A continuación pon la alarma"
            datePicker.isEnabled = true
            scheduleButton.setTitle("Poner Alarma", for: .normal)
        }
    }
    
    func presentNeedAuthorizationAlert() {
        let title = "Se Necesita Autorización"
        let message = "Las alarmas no funcionan sin notificaciones, y al parecer no has garantizado esos permisos. Por vaya a las configurciones de iOS y permita los permisos de notificaciones"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Comprendo", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func setAlarmButtonTapped(_ sender: UIButton) {
        if let alarm = Alarm.scheduled {
            alarm.unschedule()
        } else {
            let alarm = Alarm(date: datePicker.date)
            alarm.schedule { [weak self] (permissionGranted) in
                if !permissionGranted {
                    self?.presentNeedAuthorizationAlert()
                }
            }
        }
    }
}
