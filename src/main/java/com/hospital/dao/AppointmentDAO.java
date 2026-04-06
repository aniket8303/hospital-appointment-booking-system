package com.hospital.dao;

import com.hospital.model.Appointment;
import com.hospital.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.sql.Date;
import java.util.List;

public class AppointmentDAO {

    public void saveAppointment(Appointment appointment) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(appointment);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public List<Appointment> getAppointmentsByPatient(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Appointment> query = session.createQuery(
                "FROM Appointment a WHERE a.patient.userId = :patientId ORDER BY a.apptDate DESC",
                Appointment.class);
            query.setParameter("patientId", patientId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Appointment> getAppointmentsByDoctor(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Appointment> query = session.createQuery(
                "FROM Appointment a WHERE a.doctor.doctorId = :doctorId ORDER BY a.apptDate DESC",
                Appointment.class);
            query.setParameter("doctorId", doctorId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Appointment> getTodayAppointmentsByDoctor(int doctorId, Date today) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Appointment> query = session.createQuery(
                "FROM Appointment a WHERE a.doctor.doctorId = :doctorId " +
                "AND a.apptDate = :today ORDER BY a.tokenNo ASC",
                Appointment.class);
            query.setParameter("doctorId", doctorId);
            query.setParameter("today", today);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Appointment> getAllAppointments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM Appointment a ORDER BY a.apptDate DESC", Appointment.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Appointment getAppointmentById(int apptId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Appointment.class, apptId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void updateStatus(int apptId, String status) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Appointment appt = session.get(Appointment.class, apptId);
            if (appt != null) {
                appt.setStatus(status);
                session.update(appt);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void confirmAppointment(int apptId) {
        updateStatus(apptId, "confirmed");
    }

    public void cancelAppointment(int apptId) {
        updateStatus(apptId, "cancelled");
    }

    public int getNextTokenNo(int doctorId, Date date) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(a) FROM Appointment a WHERE a.doctor.doctorId = :doctorId " +
                "AND a.apptDate = :date AND a.status != 'cancelled'",
                Long.class);
            query.setParameter("doctorId", doctorId);
            query.setParameter("date", date);
            return query.uniqueResult().intValue() + 1;
        } catch (Exception e) {
            e.printStackTrace();
            return 1;
        }
    }
}
